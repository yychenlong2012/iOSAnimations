//
//  milkView.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//
#define scrW [UIScreen mainScreen].bounds.size.width
#define Dropr 10    //水滴半径
#import "milkView.h"

@interface milkView()
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravity;
@property (nonatomic,strong) UICollisionBehavior *collision;
@property (nonatomic,strong) UIDynamicItemBehavior *dynamicItem;
@property (nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic,strong) CADisplayLink *displaylink;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,assign) BOOL isBack;
@property (nonatomic,assign) NSInteger flag;
@end
@implementation milkView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.viewArray = [NSMutableArray array];
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.shapeLayer];
        self.flag = 40;
        
    }
    return self;
}
//懒加载物理仿真
-(UIDynamicAnimator *)animator{
    if(!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}
-(UIGravityBehavior *)gravity{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 2;
        // 添加到仿真器中开始仿真
        [self.animator addBehavior:_gravity];
    }
    return _gravity;
}
-(UICollisionBehavior *)collision{
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        _collision.collisionMode = UICollisionBehaviorModeEverything;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2)];
        view.backgroundColor = [UIColor blackColor];
        [self addSubview:view];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.frame];
        [_collision addBoundaryWithIdentifier:@"11" forPath:path];

        [self.animator addBehavior:_collision];
    }
    return _collision;
}
-(UIDynamicItemBehavior *)dynamicItem{   //物体属性 弹性 振幅
    if (!_dynamicItem) {
        _dynamicItem = [[UIDynamicItemBehavior alloc] init];
        _dynamicItem.elasticity = 0.4;
        [self.animator addBehavior:_dynamicItem];
    }
    return _dynamicItem;
}
-(CADisplayLink *)displaylink{
    if (!_displaylink) {
        _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePath)];
    }
    return _displaylink;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //创建新的view
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(random()%(NSInteger)(self.bounds.size.width-2*Dropr), 20, 2*Dropr, 2*Dropr);
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [self addSubview: view];
    [self.viewArray addObject:view];

    [self.gravity addItem:view];
    [self.collision addItem:view];
    [self.dynamicItem addItem:view];
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.isBack = NO;
    self.flag = 40;
}
//刷新路径
-(void)updatePath{
//    for (UIView *view in self.viewArray) {
        UIView *view = [self.viewArray lastObject];
        UIBezierPath *path;
        if (view.center.y >= 40) {
            if (self.flag > 0) {
                path = [self getBezierPathFromPoint1:CGPointMake(view.center.x, 0) radius1:60 / 2.0f Point2:CGPointMake(view.center.x, self.flag) radius2:view.bounds.size.width / 2.0f];
                self.shapeLayer.path = path.CGPath;
                self.flag -= 2;
            }else if(self.flag == 0){
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, 0)];
                [path addLineToPoint:CGPointMake(0, 0)];
                self.shapeLayer.path = path.CGPath;
            }
        }else{
            path = [self getBezierPathFromPoint1:CGPointMake(view.center.x, 0) radius1:60 / 2.0f Point2:view.center radius2:view.bounds.size.width / 2.0f];
            self.shapeLayer.path = path.CGPath;
        }
//    }
    
    
}

- (UIBezierPath *)getBezierPathFromPoint1:(CGPoint)point1 radius1:(CGFloat)r1 Point2:(CGPoint)point2 radius2:(CGFloat)r2
{
    CGFloat x1 = point1.x;
    CGFloat y1 = point1.y;
    CGFloat x2 = point2.x;
    CGFloat y2 = point2.y;
    
    CGFloat distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    
    CGFloat sinDegree = (x2 - x1) / distance;
    CGFloat cosDegree = (y2 - y1) / distance;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosDegree, y1 + r1 * sinDegree);
    CGPoint pointB = CGPointMake(x1 + r1 * cosDegree, y1 - r1 * sinDegree);
    CGPoint pointC = CGPointMake(x2 + r2 * cosDegree, y2 - r2 * sinDegree);
    CGPoint pointD = CGPointMake(x2 - r2 * cosDegree, y2 + r2 * sinDegree);
    //做了调整
    CGPoint pointN = CGPointMake(pointB.x + (distance / 2) * sinDegree-15, pointB.y + (distance / 2) * cosDegree);
    CGPoint pointM = CGPointMake(pointA.x + (distance / 2) * sinDegree+15, pointA.y + (distance / 2) * cosDegree);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 5;
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointN];
    if (self.flag != 50) {
        [path addQuadCurveToPoint:pointD controlPoint:CGPointMake(point2.x, point2.y + (2*r2)*(self.flag/40.0))];
    }else{
        [path addArcWithCenter:point2 radius:Dropr startAngle:0 endAngle:M_PI clockwise:YES];  //自己画半圆
    }
//    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointM];
    
    return path;
}

-(void)dealloc{
    [self.displaylink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.displaylink invalidate];
    self.displaylink = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

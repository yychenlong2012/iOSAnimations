//
//  springBtnView.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//
#define scrW [UIScreen mainScreen].bounds.size.width
#define smallR 15
#define bigR 25
#import "springBtnView.h"
@interface springBtnView()
@property (nonatomic,strong) UIView *smallBtnView;    //固定不动的小view
@property (nonatomic,strong) UIView *bigBtnView;      //移动的大view
@property (nonatomic,assign) BOOL isInRect;           //判断触摸点是否在按钮上
@property (nonatomic,assign) CGPoint startCenter;     //bigBtn初始中心点
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,assign) BOOL setAnimtion;        //为小按钮添加抖动动画
@end
@implementation springBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.smallBtnView = [[UIView alloc] init];
    self.smallBtnView.backgroundColor = [UIColor blueColor];
    self.smallBtnView.frame = CGRectMake(scrW/2 - smallR, 300, 2*smallR, 2*smallR);
    self.smallBtnView.layer.cornerRadius = smallR;
    self.smallBtnView.layer.masksToBounds = YES;
    [self addSubview:self.smallBtnView];
    
    self.bigBtnView = [[UIView alloc] init];
    self.bigBtnView.backgroundColor = [UIColor blueColor];
    self.bigBtnView.frame = CGRectMake(0, 0, 2*bigR, 2*bigR);
    self.bigBtnView.layer.cornerRadius = bigR;
    self.bigBtnView.layer.masksToBounds = YES;
    self.bigBtnView.center = self.smallBtnView.center;
    [self addSubview:self.bigBtnView];
    
    self.shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.shapeLayer];
    self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
    
    self.setAnimtion = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.isInRect = [self thePoint:point isInRect:self.bigBtnView.frame];
    self.startCenter = self.bigBtnView.center;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //最开始的触摸点在按钮上
    if (self.isInRect) {
        self.bigBtnView.frame = CGRectMake(point.x-bigR, point.y-bigR, 2*bigR, 2*bigR);
        [self reloadBezierPath];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.bigBtnView.center = wself.startCenter;
    }];
    self.setAnimtion = YES;
    self.shapeLayer.path = nil;
}

- (void)reloadBezierPath{
    CGFloat r1 = self.smallBtnView.frame.size.width / 2.0f;
    CGFloat r2 = self.bigBtnView.frame.size.width / 2.0f;
    
    CGFloat x1 = self.smallBtnView.center.x;
    CGFloat y1 = self.smallBtnView.center.y;
    CGFloat x2 = self.bigBtnView.center.x;
    CGFloat y2 = self.bigBtnView.center.y;
    
    CGFloat distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    if (distance > 3*bigR) {  //拉到一定距离要断裂
        self.shapeLayer.path = nil;
        if (self.setAnimtion) {
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
            anim.keyPath = @"transform.scale";
            anim.values = @[@0.9, @0.8, @0.9, @1.0, @1.1, @1.2, @1.1, @1.0];
            anim.duration = 0.25;
            [self.smallBtnView.layer addAnimation:anim forKey:nil];
            self.setAnimtion = NO;
        }
        return;
    }else{
        self.setAnimtion = YES;
    }
    
    CGFloat sinDegree = (x2 - x1) / distance;
    CGFloat cosDegree = (y2 - y1) / distance;
    
    //顶点
    CGPoint pointA = CGPointMake(x1 - r1 * cosDegree, y1 + r1 * sinDegree);
    CGPoint pointB = CGPointMake(x1 + r1 * cosDegree, y1 - r1 * sinDegree);
    CGPoint pointC = CGPointMake(x2 + r2 * cosDegree, y2 - r2 * sinDegree);
    CGPoint pointD = CGPointMake(x2 - r2 * cosDegree, y2 + r2 * sinDegree);
    //控制点
    CGPoint pointN = CGPointMake(pointB.x + (distance / 2) * sinDegree, pointB.y + (distance / 2) * cosDegree);
    CGPoint pointM = CGPointMake(pointA.x + (distance / 2) * sinDegree, pointA.y + (distance / 2) * cosDegree);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointN];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointM];
    
    self.shapeLayer.path = path.CGPath;
}

-(BOOL)thePoint:(CGPoint)point isInRect:(CGRect)rect{
    if (point.x >= rect.origin.x && point.x <= (rect.origin.x + rect.size.width)) {
        if (point.y >= rect.origin.y && point.y <= (rect.origin.y + rect.size.height)) {
            return YES;
        }
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

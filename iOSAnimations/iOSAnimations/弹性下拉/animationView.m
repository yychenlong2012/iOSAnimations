//
//  animationView.m
//  Buggy
//
//  Created by goat on 2017/12/7.
//  Copyright © 2017年 ningwu. All rights reserved.
//
#define screenW [UIScreen mainScreen].bounds.size.width
#import "animationView.h"
#import "animationTools.h"

@interface animationView()
@property (nonatomic,assign) CGPoint movePoint;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@end

@implementation animationView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.movePoint = CGPointMake(screenW/2, 100);
        self.backgroundColor = [UIColor whiteColor];
        self.shapeLayer = [CAShapeLayer layer];
        [self.shapeLayer setFillColor:[UIColor redColor].CGColor];
        [self.layer addSublayer:self.shapeLayer];
        [self updateShapeLayerPathWitePoint:self.movePoint];
    }
    return self;
}

- (void)updateShapeLayerPathWitePoint:(CGPoint)point
{
    // 更新_shapeLayer形状
    UIBezierPath *tPath = [UIBezierPath bezierPath];
    [tPath moveToPoint:CGPointMake(0, 0)];
    [tPath addLineToPoint:CGPointMake(0, 100)];
    [tPath addQuadCurveToPoint:CGPointMake(screenW, 100) controlPoint:CGPointMake(point.x, point.y)];
    [tPath addLineToPoint:CGPointMake(screenW, 0)];
    [tPath closePath];
    _shapeLayer.path = tPath.CGPath;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.movePoint = point;
    [self updateShapeLayerPathWitePoint:point];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint formPoint = [touch locationInView:self];
    
    animationTools *tools = [[animationTools alloc] init];
    __weak typeof(self) weakSelf = self;
    [tools animationWithFormPoint:formPoint toPoint:CGPointMake(screenW/2, 100) damping:5 velocity:30 duration:1 callback:^(CGPoint point) {
        [weakSelf updateShapeLayerPathWitePoint:point];
    }];
}

- (void)drawRect:(CGRect)rect {


}


//CGPoint startPoint = CGPointMake(screenW/2, 100);
//CGPoint endPoint = CGPointMake(300, 200);
//
//CGFloat damping = 5;     //越小幅度越大
//CGFloat velocity = 30;   //越大震动次数越多
//CGFloat distanceY = endPoint.y - startPoint.y;  //起点到终点之间的距离
//CGFloat distanceX = endPoint.x - startPoint.x;
//
//NSMutableArray *pointArray = [NSMutableArray array];
//for (NSInteger i = 0; i<60; i++) {
//    CGFloat x = i * 1/60.0;
//    CGFloat valueY = endPoint.y - distanceY * (pow(M_E, -damping * x) * cos(velocity * x)); //1 y = 1-e^{-5x} * cos(30x)
//    CGFloat valuex = endPoint.x - distanceX * (pow(M_E, -damping * x) * cos(velocity * x));
//    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(valuex, valueY)]];
//}
//
//CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
//anim.keyPath = @"position";
//anim.values = pointArray;
//anim.duration = 1;
//anim.fillMode=kCAFillModeForwards;
//anim.removedOnCompletion = NO;
//[self.animView.layer addAnimation:anim forKey:nil];
@end

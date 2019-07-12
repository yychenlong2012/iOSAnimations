//
//  animationTools.m
//  合集
//
//  Created by goat on 2017/12/20.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "animationTools.h"
#import <UIKit/UIKit.h>

@interface animationTools()
@property (nonatomic,strong) CADisplayLink *displaylink;
@property (nonatomic,assign) CGFloat formValue;
@property (nonatomic,assign) CGFloat toValue;
@property (nonatomic,assign) CGPoint formPoint;
@property (nonatomic,assign) CGPoint toPoint;
@property (nonatomic,assign) CGFloat damping;
@property (nonatomic,assign) CGFloat velocity;
@property (nonatomic,assign) NSInteger numberOfnum;
@property (nonatomic,assign) NSInteger beginNum;
@property (nonatomic,copy)   CallBackBlockValue callbackValue;
@property (nonatomic,copy)   CallBackBlockPoint callbackPoint;
@end
@implementation animationTools


/*
 * damping = 5;     //越小 幅度越大
 * velocity = 30;   //越大 震动次数越多
 */
-(void)animationWithFormValue:(CGFloat)formValue
                      toValue:(CGFloat)toValue
                      damping:(CGFloat)damping
                     velocity:(CGFloat)velocity
                     duration:(CGFloat)duration
                     callback:(CallBackBlockValue)callback
{
    [self.displaylink invalidate];
    self.displaylink = nil;
    self.numberOfnum = duration * 60;   //总帧数
    self.formValue = formValue;
    self.toValue = toValue;
    self.damping = damping;
    self.velocity = velocity;
    self.beginNum = 0;
    self.callbackValue = callback;
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(SEL_Displaylink_value)];
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)SEL_Displaylink_value
{
    if (self.beginNum >= self.numberOfnum) {
        [self.displaylink invalidate];
        self.displaylink = nil;
    }
    //计算
    CGFloat i = self.beginNum * 1.0/self.numberOfnum;
    CGFloat value = self.toValue - (self.toValue - self.formValue) * (pow(M_E, -self.damping * i) * cos(self.velocity * i)); //1 y = 1-e^{-5x} * cos(30x)
    if (self.callbackValue != nil) {
        self.callbackValue(value);
    }
    self.beginNum ++;
}

-(void)animationWithFormPoint:(CGPoint)formPoint
                      toPoint:(CGPoint)toPoint
                      damping:(CGFloat)damping
                     velocity:(CGFloat)velocity
                     duration:(CGFloat)duration
                     callback:(CallBackBlockPoint)callback
{
    [self.displaylink invalidate];
    self.displaylink = nil;
    self.numberOfnum = duration * 60;   //总帧数
    self.formPoint = formPoint;
    self.toPoint = toPoint;
    self.damping = damping;
    self.velocity = velocity;
    self.beginNum = 0;
    self.callbackPoint = callback;
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(SEL_Displaylink_Point)];
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)SEL_Displaylink_Point
{
    if (self.beginNum >= self.numberOfnum) {
        [self.displaylink invalidate];
        self.displaylink = nil;
    }
    //计算
    CGFloat i = self.beginNum * 1.0/self.numberOfnum;
    CGFloat x = self.toPoint.x - (self.toPoint.x - self.formPoint.x) * (pow(M_E, -self.damping * i) * cos(self.velocity * i)); //1 y = 1-e^{-5x} * cos(30x)
    CGFloat y = self.toPoint.y - (self.toPoint.y - self.formPoint.y) * (pow(M_E, -self.damping * i) * cos(self.velocity * i));
    CGPoint point = CGPointMake(x, y);
    if (self.callbackPoint != nil) {
        self.callbackPoint(point);
    }
    self.beginNum ++;
}

@end


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

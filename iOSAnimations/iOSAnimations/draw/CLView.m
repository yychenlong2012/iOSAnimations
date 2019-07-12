//
//  CLView.m
//  draw
//
//  Created by goat on 2017/11/29.
//  Copyright © 2017年 goat. All rights reserved.
//
#define scrWeith ([UIScreen mainScreen].bounds.size.width)
/*
 point为旋转前的点
 anchorPoint 围绕该点旋转
 angle  旋转角
 */
#define pointRotatedAroundAnchorPoint(point,anchorPoint,angle) CGPointMake((point.x-anchorPoint.x)*cos(angle) - (point.y-anchorPoint.y)*sin(angle) + anchorPoint.x, (point.x-anchorPoint.x)*sin(angle) + (point.y-anchorPoint.y)*cos(angle)+anchorPoint.y)

#import "CLView.h"

@interface CLView()
@property (nonatomic,strong) NSMutableArray<UIView *> *viewArray;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint movedPoint;
@property (nonatomic,strong) UIBezierPath *currentPath;   //当前手动绘制的路径
@property (nonatomic,strong) NSMutableArray<NSMutableArray *> *pathArray;   //所有的路径
@property (nonatomic,strong) NSMutableArray<UIBezierPath *> *otherPath;   //其他象限的路径
@property (nonatomic,strong) NSMutableArray<UIColor *> *colorArray;
@end
@implementation CLView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.lineColor = [UIColor whiteColor];
        self.viewArray = [NSMutableArray array];
        self.pathArray = [NSMutableArray array];
        self.otherPath = [NSMutableArray array];
        self.colorArray =[NSMutableArray array];
        for (NSInteger i = 0; i<4; i++) {
            UIView *v = [[UIView alloc] init];
            v.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
            [self addSubview:v];
            [self.viewArray addObject:v];
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i<self.viewArray.count; i++) {
        UIView *v = self.viewArray[i];
        if (i%2 == 1) {
            v.frame = CGRectMake(0, 0, 1, scrWeith + 140);
        }else{
            v.frame = CGRectMake(0, 0, 1, scrWeith);
        }
        v.center = CGPointMake(scrWeith/2, scrWeith/2);
        //旋转
        v.layer.transform = CATransform3DMakeRotation(M_PI_2/2 * i, 0, 0, 1);
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self];
    self.movedPoint = self.startPoint;
    
    //新建一条线
    self.currentPath = [[UIBezierPath alloc] init];
    [self.currentPath moveToPoint:self.startPoint];
    self.currentPath.flatness = 0.1;   //默认0.6 值越小曲线越平滑
//    self.currentPath.usesEvenOddFillRule = YES;
//    [self.currentPath fill];
    //其他象限的路径
    for (NSInteger i = 0; i<(self.numberOfSide - 1); i++) {
        CGPoint point = pointRotatedAroundAnchorPoint(self.startPoint, CGPointMake(scrWeith/2, scrWeith/2), (M_PI*2/self.numberOfSide) * (i+1));
        UIBezierPath *path = [[UIBezierPath alloc] init];
        path.flatness = 0.1;
//        path.usesEvenOddFillRule = YES;
//        [path fill];
        [path moveToPoint:point];
        [self.otherPath addObject:path];
    }
    //保存颜色
    [self.colorArray addObject:self.lineColor];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.movedPoint = [touch locationInView:self];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //整合
    [self.otherPath addObject:self.currentPath];
    self.currentPath = nil;
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.otherPath];
    [self.pathArray addObject:temp];
    [self.otherPath removeAllObjects];
    
}

//下面提供了两种方式，一种需要用到上下文 另一种不需要上下文
- (void)drawRect:(CGRect)rect {
    ///要操作上下文
//    //获得上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    //1、之前保存的路径
//    for (NSInteger i = 0; i<self.pathArray.count; i++) {
//        //保存上下文状态
//        CGContextSaveGState(ctx);
//        //修改当前上下文的状态，不影响以保存的上下文状态
//        [self.colorArray[i] set];
//        CGContextSetLineWidth(ctx, 1);
//
//        NSArray *array = self.pathArray[i];
//        for (UIBezierPath *path in array) {
//            //保存路径到上下文
//            CGContextAddPath(ctx, path.CGPath);
//        }
//        //把上下文的状态渲染到view上
//        CGContextStrokePath(ctx);
//    }
//
//    //2、正在画的路径
//    //保存上下文状态
//    CGContextSaveGState(ctx);
//    //修改上下文状态，不影响上面已保存的上下文状态
//    [self.lineColor set];
//    CGContextSetLineWidth(ctx, 1);
//    //保存路径
//    [self.currentPath addLineToPoint:self.movedPoint];
//    CGContextAddPath(ctx, self.currentPath.CGPath);
//
//    for (NSInteger i = 0; i<self.otherPath.count; i++) {
//        UIBezierPath *path = self.otherPath[i];
//        CGPoint point = pointRotatedAroundAnchorPoint(self.movedPoint, CGPointMake(scrWeith/2, scrWeith/2), (M_PI*2/self.numberOfSide) * (i+1));
//        [path addLineToPoint:point];
//        //保存路径
//        CGContextAddPath(ctx, path.CGPath);
//    }
//    //把上下文的状态渲染到view上
//    CGContextStrokePath(ctx);
    
//    return;
    
    ///不需要用到上下文
    for (NSInteger i = 0; i<self.pathArray.count; i++) {
        NSArray *array = self.pathArray[i];
        for (UIBezierPath *path in array) {
            [self.colorArray[i] set];
            [path stroke];
        }
    }
    
    [self.currentPath addLineToPoint:self.movedPoint];
    [self.lineColor set];
    self.currentPath.lineWidth = 1;
    [self.currentPath stroke];
    
    //其他路径
    for (NSInteger i = 0; i<self.otherPath.count; i++) {
        UIBezierPath *path = self.otherPath[i];
        CGPoint point = pointRotatedAroundAnchorPoint(self.movedPoint, CGPointMake(scrWeith/2, scrWeith/2), (M_PI*2/self.numberOfSide) * (i+1));
        [path addLineToPoint:point];
        [self.lineColor set];
        path.lineWidth = 1;
        [path stroke];
    }
}

//清除所有路径
-(void)removeAllPath
{
    [self.otherPath removeAllObjects];
    self.currentPath = nil;
    [self.pathArray removeAllObjects];
    [self.colorArray removeAllObjects];
    [self setNeedsDisplay];
}


@end


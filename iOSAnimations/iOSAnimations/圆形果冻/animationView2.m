//
//  animationView2.m
//  Buggy
//
//  Created by goat on 2017/12/8.
//  Copyright © 2017年 ningwu. All rights reserved.
//
#define screenW [UIScreen mainScreen].bounds.size.width
#define R 50   //小球半径
#import "animationView2.h"
@interface animationView2()<NSURLSessionDelegate>
@property (nonatomic,strong) CAShapeLayer *shapLayer;
@property (nonatomic,assign) CGFloat factor;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,strong) UIView *animView;
@property (nonatomic,assign) CGFloat curveX;
@property (nonatomic,strong) CADisplayLink *displayLink;
@end
@implementation animationView2
static NSString *kX = @"curveX";
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.shapLayer = [CAShapeLayer layer];
        self.shapLayer.fillColor = [UIColor colorWithRed:68/255.0 green:1 blue:188/255.0 alpha:0.7].CGColor;
        [self.layer addSublayer:self.shapLayer];
        
        //圆中心
        CGPoint center = CGPointMake(screenW/2, 300);
        //初始化4个定点
        CGPoint A = CGPointMake(center.x, center.y - R);
        CGPoint B = CGPointMake(center.x + R, center.y);
        CGPoint C = CGPointMake(center.x, center.y + R);
        CGPoint D = CGPointMake(center.x - R, center.y);
        //控制点的偏移量
        CGFloat offset = 2*R/3.60;
        //算出控制点
        CGPoint A_right = CGPointMake(A.x + offset, A.y);
        CGPoint B_top   = CGPointMake(B.x, B.y - offset);
        CGPoint B_bottom= CGPointMake(B.x, B.y + offset);
        CGPoint C_right = CGPointMake(C.x + offset, C.y);
        CGPoint C_left  = CGPointMake(C.x - offset, C.y);
        CGPoint D_bottom= CGPointMake(D.x, D.y + offset);
        CGPoint D_top   = CGPointMake(D.x, D.y - offset);
        CGPoint A_left  = CGPointMake(A.x - offset, A.y);
        //创建路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:A];
        [path addCurveToPoint:B controlPoint1:A_right controlPoint2:B_top];
        [path addCurveToPoint:C controlPoint1:B_bottom controlPoint2:C_right];
        [path addCurveToPoint:D controlPoint1:C_left controlPoint2:D_bottom];
        [path addCurveToPoint:A controlPoint1:D_top controlPoint2:A_left];
        
        self.shapLayer.path = path.CGPath;
        
        //做动画的view
        self.animView = [[UIView alloc] init];
        self.animView.frame = CGRectMake(B.x, B.y, 3, 3);
        [self addSubview:self.animView];
        self.animView.backgroundColor = [UIColor clearColor];
        [self addObserver:self forKeyPath:kX options:NSKeyValueObservingOptionNew context:nil];
    
    }
    return self;
}

-(void)removeFromSuperview
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:kX];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kX]) {
        [self updateShapeLayerPathWitePoint:_curveX];
    }
}

- (void)updateShapeLayerPathWitePoint:(CGFloat)pointx
{
    //圆中心
    CGPoint center = CGPointMake(screenW/2, 300);

    //初始化4个定点
    CGPoint A = CGPointMake(center.x, center.y - R);
    CGPoint B = CGPointMake(pointx, center.y);
    CGPoint C = CGPointMake(center.x, center.y + R);
    CGPoint D = CGPointMake(center.x - R, center.y);
    //控制点的偏移量
    CGFloat offset = 2*R/3.60;
    //算出控制点
    CGPoint A_right = CGPointMake(A.x + offset, A.y);
    CGPoint B_top   = CGPointMake(B.x, B.y - offset);
    CGPoint B_bottom= CGPointMake(B.x, B.y + offset);
    CGPoint C_right = CGPointMake(C.x + offset, C.y);
    CGPoint C_left  = CGPointMake(C.x - offset, C.y);
    CGPoint D_bottom= CGPointMake(D.x, D.y + offset);
    CGPoint D_top   = CGPointMake(D.x, D.y - offset);
    CGPoint A_left  = CGPointMake(A.x - offset, A.y);
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:A];
    [path addCurveToPoint:B controlPoint1:A_right controlPoint2:B_top];
    [path addCurveToPoint:C controlPoint1:B_bottom controlPoint2:C_right];
    [path addCurveToPoint:D controlPoint1:C_left controlPoint2:D_bottom];
    [path addCurveToPoint:A controlPoint1:D_top controlPoint2:A_left];
    
    self.shapLayer.path = path.CGPath;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //限制最大的便宜距离为小球的直径  算出便宜的比例系数
    CGFloat a = 0;
    CGFloat scale = 0;
    if ((point.x - self.startPoint.x) >= 2*R){
        a = 2*R;
        scale = 1;
    }else{
        a = point.x - self.startPoint.x;
        scale = (point.x - self.startPoint.x)/(2*R) * 0.2;
    }
//    CGFloat scaleY = 0;
//    if ((point.y - self.startPoint.y) >= 2*R)
//        scaleY = 1;
//    else
//        scaleY = (point.y - self.startPoint.y)/2*R;
    //圆中心
    CGPoint center = CGPointMake(screenW/2, 300);
    //初始化4个定点
    CGPoint A = CGPointMake(center.x, center.y - R*(1-scale));
    CGPoint B = CGPointMake(center.x + R + a, center.y);
    CGPoint C = CGPointMake(center.x, center.y + R*(1-scale));
    CGPoint D = CGPointMake(center.x - R, center.y);
    //控制点的偏移量
    CGFloat offset = 2*R/3.60;
    //算出控制点
    CGPoint A_right = CGPointMake(A.x + offset, A.y);
    CGPoint B_top   = CGPointMake(B.x, B.y - offset);
    CGPoint B_bottom= CGPointMake(B.x, B.y + offset);
    CGPoint C_right = CGPointMake(C.x + offset, C.y);
    CGPoint C_left  = CGPointMake(C.x - offset, C.y);
    CGPoint D_bottom= CGPointMake(D.x, D.y + offset);
    CGPoint D_top   = CGPointMake(D.x, D.y - offset);
    CGPoint A_left  = CGPointMake(A.x - offset, A.y);
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:A];
    [path addCurveToPoint:B controlPoint1:A_right controlPoint2:B_top];
    [path addCurveToPoint:C controlPoint1:B_bottom controlPoint2:C_right];
    [path addCurveToPoint:D controlPoint1:C_left controlPoint2:D_bottom];
    [path addCurveToPoint:A controlPoint1:D_top controlPoint2:A_left];
    
    self.shapLayer.path = path.CGPath;
    
    self.animView.frame = CGRectMake(B.x, B.y, 3, 3);
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat scaleX = 0;
    CGFloat a = 0;
    if ((point.x - self.startPoint.x) >= 2*R){
        scaleX = 1;
        a = 2*R;
    }else{
        scaleX = (point.x - self.startPoint.x)/(2.0*R);
        a = point.x - self.startPoint.x;
    }
    //圆中心
    CGPoint center = CGPointMake(screenW/2, 300);
    
    //dampingRatio：阻尼系数，范围为 0.0 ~ 1.0，数值越小，弹簧振动的越厉害
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.animView.frame = CGRectMake(center.x + R, center.y, 3, 3);
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePoint)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)updatePoint
{
    CALayer *layer = self.animView.layer.presentationLayer;
    self.curveX = layer.position.x;
}

#pragma mark - nsurlsessiondelegate



@end

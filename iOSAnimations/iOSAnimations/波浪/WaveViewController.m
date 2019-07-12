//
//  WaveViewController.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//
#define scrW ([UIScreen mainScreen].bounds.size.width)
#import "WaveViewController.h"
#import "animationTools.h"

@interface WaveViewController ()
@property (nonatomic,strong) CADisplayLink *display;
@property (nonatomic,strong) CAShapeLayer *shapLayer;
@property (nonatomic,strong) CAShapeLayer *shapLayer2;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,assign) CGFloat rate;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation WaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rate = 1;
    [self setupUI];
    
    //黑色圆圈
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(150, 350, 100, 100);
    view.layer.cornerRadius = 50;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 20;
    view.layer.shadowOpacity = 1;
    [self.view addSubview:view];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.display invalidate];
    self.display = nil;
}

-(void)setupUI2{
    self.shapLayer = [CAShapeLayer layer];
    self.shapLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapLayer.lineWidth = 8;
    self.shapLayer.lineDashPattern = @[@(0),@(15)];   //设置虚线
    self.shapLayer.lineCap = @"round";
    [self.view.layer addSublayer:self.shapLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 100)];
    [path addLineToPoint:CGPointMake(300, 100)];
    self.shapLayer.path = path.CGPath;
    
//    self.shapLayer2 = [CAShapeLayer layer];
//    self.shapLayer2.fillColor = [UIColor clearColor].CGColor;
//    self.shapLayer2.strokeColor = [UIColor greenColor].CGColor;
//    self.shapLayer2.lineWidth = 4;
//    self.shapLayer2.lineDashPattern = @[@(8),@(8)];
//    [self.view.layer addSublayer:self.shapLayer2];
//
//    UIBezierPath *path2 = [UIBezierPath bezierPath];
//    [path2 moveToPoint:CGPointMake(8, 100)];      //右移8个点
//    [path2 addLineToPoint:CGPointMake(300, 100)];
//    self.shapLayer2.path = path2.CGPath;
}

-(void)setupUI{
    self.shapLayer = [CAShapeLayer layer];
    self.shapLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapLayer.lineWidth = 2;
    self.shapLayer.lineDashPattern = @[@(8),@(8)];   //设置虚线
    [self.view.layer addSublayer:self.shapLayer];
    
    self.shapLayer2 = [CAShapeLayer layer];
    self.shapLayer2.fillColor = [UIColor clearColor].CGColor;
    self.shapLayer2.strokeColor = [UIColor greenColor].CGColor;
    self.shapLayer2.lineWidth = 2;
    self.shapLayer2.lineDashPattern = @[@(8),@(8)];
    [self.view.layer addSublayer:self.shapLayer2];
    
    CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawWaveLine)];
    [display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.display = display;
    self.duration = 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    animationTools *tool = [[animationTools alloc] init];
    __weak typeof(self) weakSelf = self;
    [tool animationWithFormValue:1 toValue:3 damping:3 velocity:30 duration:5 callback:^(CGFloat value) {
        weakSelf.rate = value;
    }];
}


-(void)drawWaveLine
{
    //创建一个路径
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGMutablePathRef path2 = CGPathCreateMutable();
    
    CGFloat y1 = 100;
//    CGPathMoveToPoint(path1, nil, 0, y1);   //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(path1, nil, 0, y1-8);
    CGPathAddLineToPoint(path1, nil, 0, y1);
    
    CGFloat y2 = 100;
    CGPathMoveToPoint(path2, nil, 0, y2);
    
    for (NSInteger x = 0.0f; x<=scrW; x++) {
        //标准正玄波浪公式
//        y = (20) * sin((1/30.0)*x+ self.duration)+100;
        //再乘上一个正弦函数 变成非标准三角函数
        y1 = self.rate * sin((M_PI/scrW)*x) * (20 * sin((1/30.0)*x + self.duration)) + 100;
        CGPathAddLineToPoint(path1, nil, x, y1);
        
//        y2 = self.rate * sin((M_PI/scrW)*x) * (20 * sin((1/30.0)*x + self.duration + 20)) + 100;
        y2 = self.rate * sin((M_PI/scrW)*x) * (20 * sin((1/30.0)*x + self.duration)) + 100;
        CGPathAddLineToPoint(path2, nil, x, y2);
    }
    CGPathAddLineToPoint(path1, nil, scrW, self.view.frame.size.height);
    CGPathAddLineToPoint(path1, nil, 0, self.view.frame.size.height);
    CGPathCloseSubpath(path1);
    self.shapLayer.path = path1;
    CGPathRelease(path1);
    
    CGPathAddLineToPoint(path2, nil, scrW, self.view.frame.size.height);
    CGPathAddLineToPoint(path2, nil, 0, self.view.frame.size.height);
    CGPathCloseSubpath(path2);
    self.shapLayer2.path = path2;
    CGPathRelease(path2);
    
    self.duration += 0.1;
    if (self.duration > 60*M_PI) {
        self.duration = 0;
    }
    
    return;
    
    //    UIBezierPath *path = [UIBezierPath bezierPath];
    //
    //    CGPoint point1 = CGPointMake(0, 100);
    //    CGPoint point2 = CGPointMake(scrW, 200);
    //    CGPoint point3 = CGPointMake(0, 200);
    //
    //    [path moveToPoint:point1];
    //    for (NSInteger x = 0; x<=scrW; x++) {
    //        CGFloat y = 10 * sin(1/3.0 * x+ 20)+100;
    //        [path addLineToPoint:CGPointMake(x, y)];
    //    }
    //    [path addLineToPoint:point2];
    //    [path addLineToPoint:point3];
    //    [path closePath];
    //
    //    self.shapLayer.path = (__bridge CGPathRef _Nullable)(path);
}


@end

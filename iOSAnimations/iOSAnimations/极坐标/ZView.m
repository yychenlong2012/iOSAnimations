//
//  ZJBView.m
//  合集
//
//  Created by goat on 2017/12/14.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "ZView.h"
@interface ZView()
@property (nonatomic,strong) CADisplayLink *displaylink;
@property (nonatomic,assign) CGFloat startAngle;
@property (nonatomic,assign) CGFloat endAngle;
@property (nonatomic,assign) CGFloat R;
@property (nonatomic,strong) UIBezierPath *path;
@end
@implementation ZView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.R = 0;
        self.startAngle = 0;
        self.endAngle = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        self.path = [UIBezierPath bezierPath];
        [self.path moveToPoint:CGPointMake(200, 200)];
        self.path.lineWidth = 3;
        
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.displaylink invalidate];
    self.displaylink = nil;
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(SEL_displaylink)];
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)SEL_displaylink
{
    self.endAngle += 0.1;
    self.R += 0.1;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [self.path addArcWithCenter:CGPointMake(200, 200) radius:self.R startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    self.startAngle = self.endAngle;
    
    [[UIColor blackColor] set];
    [self.path stroke];
    
}


@end

//
//  colorImageView.m
//  draw
//
//  Created by goat on 2017/11/30.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "colorImageView.h"
#import "UIView+color.h"
@interface colorImageView()
@property (nonatomic,strong) UIView *displayView;     //展示所选颜色的view
@end

@implementation colorImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"color"];
        self.userInteractionEnabled = YES;
        //展示颜色的view
        UIView *v = [[UIView alloc] init];
        v.frame = CGRectMake(0, -40, 40, 40);
        [self addSubview:v];
        self.displayView = v;
    }
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.displayView.backgroundColor = [self colorOfPoint:touchPoint];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self];
    self.displayView.backgroundColor = [self colorOfPoint:movePoint];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self];
    self.displayView.backgroundColor = [self colorOfPoint:endPoint];
    [self.delegate colorSelectEnd:[self colorOfPoint:endPoint]]; //代理
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

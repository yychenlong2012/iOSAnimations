//
//  touchAnimationViewController.m
//  合集
//
//  Created by goat on 2017/12/20.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "touchAnimationViewController.h"


@interface touchAnimationViewController ()
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,strong) CABasicAnimation *anim;
@end

@implementation touchAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, screenH-30, screenW-20, 20)];
    slider.maximumValue = 1.0;
    slider.minimumValue = 0.0;
    slider.value = 0.0;
    [slider addTarget:self action:@selector(SEL_SliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.backgroundColor = [UIColor greenColor];
    imageview.frame = CGRectMake(0, 100, 100, 100);
//    imageview.center = self.view.center;
    [self.view addSubview:imageview];
    self.imageview = imageview;
    
//    CABasicAnimation *anim = [CABasicAnimation animation];
//    anim.keyPath = @"transform.scale";
//    anim.fromValue = @0.0;
//    anim.toValue = @(M_PI);
//    anim.duration = 1.0;
//    anim.repeatCount = 1;
//    self.anim = anim;
//    [self.imageview.layer addAnimation:anim forKey:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation.z";
    anim.fromValue = @0.0;
    anim.toValue = @(M_PI);
    anim.duration = 1.0;
    anim.repeatCount = 1;
    [self.imageview.layer addAnimation:anim forKey:nil];
    self.imageview.layer.speed = 0;   //动画处于暂停状态
    
    animationTools *tools = [[animationTools alloc] init];
    __weak typeof(self) weakSelf = self;
    [tools animationWithFormValue:0 toValue:100 damping:5 velocity:10 duration:1 callback:^(CGFloat value) {
        CGRect frame = weakSelf.imageview.frame;
        frame.origin.x = value;
        weakSelf.imageview.frame = frame;
        NSLog(@"%f",value);
    }];
    

}

-(void)SEL_SliderValueChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.imageview.layer.timeOffset = slider.value;  //控制动画进度
}
-(void)dealloc{
    NSLog(@"dealloc");
}
/*
 //CATransform3D Key Paths : (example)transform.rotation.z
 //rotation.x
 //rotation.y
 //rotation.z
 //rotation 旋轉
 //scale.x
 //scale.y
 //scale.z
 //scale 缩放
 //translation.x
 //translation.y
 //translation.z
 //translation 平移
 
 //CGPoint Key Paths : (example)position.x
 //x
 //y
 
 //CGRect Key Paths : (example)bounds.size.width
 //origin.x
 //origin.y
 //origin
 //size.width
 //size.height
 //size
 
 //opacity
 //backgroundColor
 //cornerRadius
 //borderWidth
 //contents
 
 //Shadow Key Path:
 //shadowColor
 //shadowOffset
 //shadowOpacity
 //shadowRadius
 
 作者：明仔Su
 链接：http://www.jianshu.com/p/d05d19f70bac
 來源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */

@end

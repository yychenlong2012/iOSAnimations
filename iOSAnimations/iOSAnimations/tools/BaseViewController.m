//
//  BaseViewController.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//


#import "BaseViewController.h"
#import <Lottie/Lottie.h>


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UILabel *back = [[UILabel alloc] init];
    back.text = @"back";
    back.textColor = [UIColor redColor];
    back.font = [UIFont systemFontOfSize:14];
    back.frame = CGRectMake(15, 25, 70, 20);
    back.userInteractionEnabled = YES;
    [self.view addSubview:back];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swip)];
    [back addGestureRecognizer:tap];
}

-(void)swip{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

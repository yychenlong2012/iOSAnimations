//
//  JellyAnimtionViewController.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "JellyAnimtionViewController.h"
#import "animationView2.h"

@interface JellyAnimtionViewController ()

@end

@implementation JellyAnimtionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    animationView2 *view = [[animationView2 alloc] init];
    view.frame = CGRectMake(0, 100, screenW, screenH-100);
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

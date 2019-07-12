//
//  BtnViewController.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "BtnViewController.h"
#import "springBtnView.h"

@interface BtnViewController ()

@end

@implementation BtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    springBtnView *view = [[springBtnView alloc] init];
    view.backgroundColor = [UIColor cyanColor];
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

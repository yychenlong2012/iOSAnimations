//
//  RefershViewController.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "RefershViewController.h"
#import "animationView.h"

@interface RefershViewController ()

@end

@implementation RefershViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    animationView *view = [[animationView alloc] init];
    view.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100);
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

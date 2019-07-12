//
//  JZBViewController.m
//  合集
//
//  Created by goat on 2017/12/14.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "JZBViewController.h"
#import "ZView.h"
#import "MilkViewController.h"

@implementation JZBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ZView *view = [[ZView alloc] init];
    view.frame = CGRectMake(0, 100, screenW, screenH-100);
    [self.view addSubview:view];
    
//    @try {
//        NSArray *a = [NSArray array];
//        @[][1];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",[exception reason]);
//    }
//    @finally {
//
//    }
    
    
//    UITabBarController *ta =  [[UITabBarController alloc] init];
//
//    UIViewController *vc = [[UIViewController alloc] init];
//
//    vc.title = @"ni";
//
//    vc.view.backgroundColor = [UIColor greenColor];
//
//    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"asd" image:nil selectedImage:nil];
//
//    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
//
//    MilkViewController *vc2 = [[MilkViewController alloc] init];
//
//    vc2.title = @"ad";
//
//    vc2.view.backgroundColor = [UIColor yellowColor];
//
//    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"222" image:nil selectedImage:nil];
//
//    UINavigationController *na2 = [[UINavigationController alloc] initWithRootViewController:vc2];
//
//    ta.viewControllers = @[na,na2];
//
//    [UIApplication sharedApplication].delegate.window.rootViewController = ta;
}




@end

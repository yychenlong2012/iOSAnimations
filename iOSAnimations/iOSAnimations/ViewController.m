//
//  ViewController.m
//  iOSAnimations
//
//  Created by goat on 2019/7/12.
//  Copyright © 2019 3Pomelos. All rights reserved.
//

#import "ViewController.h"
#import "DrawViewController.h"
#import "WaveViewController.h"
#import "BaseViewController.h"
#import "JellyAnimtionViewController.h"
#import "RefershViewController.h"
#import "BtnViewController.h"
#import "MilkViewController.h"
#import "lottieAnimViewController.h"
#import "vocieWaveViewController.h"
#import "JZBViewController.h"
#import "motionViewController.h"
#import "touchAnimationViewController.h"
#import "VoiceViewController.h"
#import "playmusicViewController.h"
#import "CalenderViewController.h"
#import "emitterViewController.h"
#import "PanoramaViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;     //标题

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = @[@"draw",@"弦波浪",@"圆形果冻",@"弹性下拉",@"粘性按钮",@"牛奶效果",@"lottie动画",@"变化的波浪线",@"极坐标",@"陀螺仪",@"交互式动画",@"录音",@"播放音乐",@"日历",@"粒子飘动",@"全景图"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarH, ScreenWidth, ScreenHeight-statusBarH-bottomSafeH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{    return 1;   }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{    return self.titleArray.count;   }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{    return 44;    }
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *vc = nil;
    switch (indexPath.row) {
        case 0:{
            vc = [[DrawViewController alloc] init];
        }break;
        case 1:{
            vc = [[WaveViewController alloc] init];
        }break;
        case 2:{
            vc = [[JellyAnimtionViewController alloc] init];
        }break;
        case 3:{
            vc = [[RefershViewController alloc] init];
        }break;
        case 4:{
            vc = [[BtnViewController alloc] init];
        }break;
        case 5:{
            vc = [[MilkViewController alloc] init];
        }break;
        case 6:{
            vc = [[lottieAnimViewController alloc] init];
        }break;
        case 7:{
            vc = [[vocieWaveViewController alloc] init];
        }break;
        case 8:{
            vc = [[JZBViewController alloc] init];
        }break;
        case 9:{
            vc = [[motionViewController alloc] init];
        }break;
        case 10:{
            vc = [[touchAnimationViewController alloc] init];
        }break;
        case 11:{
            vc = [[VoiceViewController alloc] init];
        }break;
        case 12:{
            vc = [[playmusicViewController alloc] init];
        }break;
        case 13:{
            vc = [[CalenderViewController alloc] init];
        }break;
        case 14:{
            vc = [[emitterViewController alloc] init];
        }break;
        case 15:{
            vc = [[PanoramaViewController alloc] init];
        }break;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

@end

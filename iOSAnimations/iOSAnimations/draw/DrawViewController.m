//
//  DrawViewController.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//
#define scrWeith ([UIScreen mainScreen].bounds.size.width)
#define scrHeight ([UIScreen mainScreen].bounds.size.height)
#import "DrawViewController.h"
#import "CLView.h"
#import "colorImageView.h"

@interface DrawViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,ColorImageViewDelegate>
@property (nonatomic,strong) CLView *drawView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *colorBtn;
@property (nonatomic,strong) colorImageView *colorImageV;
@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLView *view = [[CLView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(0, 50, scrWeith, scrWeith);
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    view.layer.borderWidth = 1;
    view.numberOfSide = 50;
    [self.view addSubview:view];
    self.drawView = view;
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.layer.borderColor = [UIColor blackColor].CGColor;
    self.picker.layer.borderWidth = 1;
    [self.picker selectRow:49 inComponent:0 animated:YES];
    
    self.colorImageV = [[colorImageView alloc] init];
    self.colorImageV.frame = CGRectMake(70,scrHeight - (scrWeith -70),scrWeith-70,scrWeith-70);
    [self.view addSubview:self.colorImageV];
    self.colorImageV.hidden = YES;
    self.colorImageV.delegate = self;
}
- (IBAction)removeAllPath:(id)sender {
    [self.drawView removeAllPath];
}
- (IBAction)selectColor:(id)sender {
    if (self.colorImageV.hidden == YES)
        self.colorImageV.hidden = NO;
    else
        self.colorImageV.hidden = YES;
}

#pragma mark -
-(void)colorSelectEnd:(UIColor *)color
{
    self.drawView.lineColor = color;
    //设置按钮颜色
    [self.colorBtn setTitleColor:color forState:UIControlStateNormal];
}

#pragma mark -
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 100;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld",row+1];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.drawView.numberOfSide = row+1;
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

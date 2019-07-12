//
//  CLView.h
//  draw
//
//  Created by goat on 2017/11/29.
//  Copyright © 2017年 goat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLView : UIView
@property (nonatomic,assign) NSInteger numberOfSide;  //细分出几条边
@property (nonatomic,strong) UIColor *lineColor;      //线条颜色
//清除所有路径
-(void)removeAllPath;
@end

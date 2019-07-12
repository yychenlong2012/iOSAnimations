//
//  colorImageView.h
//  draw
//
//  Created by goat on 2017/11/30.
//  Copyright © 2017年 goat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ColorImageViewDelegate<NSObject>
-(void)colorSelectEnd:(UIColor *)color;
@end

@interface colorImageView : UIImageView
@property (nonatomic,weak) id<ColorImageViewDelegate> delegate;
@property (nonatomic,strong) UIColor *currentColor;   //当前选中的颜色
@end

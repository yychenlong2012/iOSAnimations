//
//  animationTools.h
//  合集
//
//  Created by goat on 2017/12/20.
//  Copyright © 2017年 goat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^CallBackBlockValue)(CGFloat value);
typedef void(^CallBackBlockPoint)(CGPoint point);
@interface animationTools : NSObject
//单个值的震荡
-(void)animationWithFormValue:(CGFloat)formValue
                      toValue:(CGFloat)toValue
                      damping:(CGFloat)damping
                     velocity:(CGFloat)velocity
                     duration:(CGFloat)duration
                     callback:(CallBackBlockValue)callback;

//点的震荡
-(void)animationWithFormPoint:(CGPoint)formPoint
                      toPoint:(CGPoint)toPoint
                      damping:(CGFloat)damping
                     velocity:(CGFloat)velocity
                     duration:(CGFloat)duration
                     callback:(CallBackBlockPoint)callback;
@end

//
//  CONST.h
//  合集
//
//  Created by goat on 2017/12/20.
//  Copyright © 2017年 goat. All rights reserved.
//

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width


//获取设备物理高度
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
//获取设备物理宽度
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
//状态栏高度
#define statusBarH ([UIApplication sharedApplication].statusBarFrame.size.height)   //(44/20)  z状态栏高度
//是否为全面屏  iPhone X和后面的产品
#define isFullScreen ((statusBarH == 44.0) ? YES : NO)
//导航栏高度
#define navigationH (statusBarH + 44.0)
//bottom安全区高度
#define bottomSafeH (isFullScreen ? 34 : 0)
//tabber高度 包括底部安全区
#define tabbarH (bottomSafeH + 49)


//十六进制颜色值转UIColor
#define kHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kHexRGBA(rgbValue,alphaNum) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaNum]
#define RGBAColor(r, g, b, alphaNum) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:alphaNum]
#define kWhiteColorA(alphaNum)  RGBAColor(0xFF, 0xFF, 0xFF, alphaNum)      // 白色
#define kBlackColorA(alphaNum)  RGBAColor(0   , 0   , 0   , alphaNum)
#define kRedColorA(alphaNum)    RGBAColor(0xFF, 0   , 0   , alphaNum)
#define kOrangeColorA(alphaNum) RGBAColor(0xFF, 0x7F, 0   , alphaNum)
#define kYellowColorA(alphaNum) RGBAColor(0xFF, 0xFF, 0   , alphaNum)
#define kGreenColorA(alphaNum)  RGBAColor(0   , 0xFF, 0   , alphaNum)
#define kBlueColorA(alphaNum)   RGBAColor(0   , 0   , 0xFF, alphaNum)
#define kCyanColorA(alphaNum)   RGBAColor(0   , 0xFF, 0xFF, alphaNum)        //青色
#define kPurpleColorA(alphaNum) RGBAColor(0x8B, 0   , 0xFF, alphaNum)

#define kWhiteColor [UIColor whiteColor]      // 白色
#define kBlackColor [UIColor blackColor]
#define kRedColor   [UIColor redColor]
#define kOrangeColor [UIColor orangeColor]
#define kYellowColor [UIColor yellowColor]
#define kGreenColor [UIColor greenColor]
#define kBlueColor [UIColor blueColor]
#define kCyanColor [UIColor cyanColor]        //青色
#define kPurpleColor [UIColor purpleColor]
#define kClearColor [UIColor clearColor]
#define kGrayColor [UIColor grayColor]
#define kLightGrayColor [UIColor lightGrayColor]
#define kLightTextColor [UIColor lightTextColor]
//随机颜色
#define kRandomColor  [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1.0]

//label的实际高度 = font字体大小 * 1.2
#define RealLabelHeight(value) (value*1.2)

//偏好设置
#define KUserDefualt [NSUserDefaults standardUserDefaults]
#define KUserDefualt_Get(key) [KUserDefualt objectForKey:key]
#define KUserDefualt_Set(obejct,key) [KUserDefualt setObject:obejct forKey:key]

//window
#define kKeyWindow [[[UIApplication sharedApplication] delegate] window]

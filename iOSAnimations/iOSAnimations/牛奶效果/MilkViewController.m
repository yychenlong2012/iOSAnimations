//
//  MilkViewController.m
//  合集
//
//  Created by goat on 2017/12/13.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "MilkViewController.h"
#import "milkView.h"
#import "milkView2.h"

@interface MilkViewController ()
@property (nonatomic,strong) NSMutableData *dataM;
@end

@implementation MilkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    milkView2 *view = [[milkView2 alloc] init];
    view.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 500);
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


/*emoji
 
 -(NSString *)decodeUnicodeBytes:(char *)stringEncoded {
 unsigned int    unicodeValue;
 char            *p, buff[5];
 NSMutableString *theString;
 NSString        *hexString;
 NSScanner       *pScanner;
 
 theString = [[NSMutableString alloc] init];
 p = stringEncoded;
 
 buff[4] = 0x00;
 while (*p != 0x00) {
 
 if (*p == '\\') {
 p++;
 if (*p == 'u') {
 memmove(buff, ++p, 4);
 
 hexString = [NSString stringWithUTF8String:buff];
 pScanner = [NSScanner scannerWithString: hexString];
 [pScanner scanHexInt: &unicodeValue];
 
 [theString appendFormat:@"%C", (unichar)unicodeValue];
 p += 4;
 continue;
 }
 }
 
 [theString appendFormat:@"%c", *p];
 p++;
 }
 
 return [NSString stringWithString:theString];
 }
 */

@end

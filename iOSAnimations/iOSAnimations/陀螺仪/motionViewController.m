//
//  motionViewController.m
//  合集
//
//  Created by goat on 2017/12/19.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "motionViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface motionViewController ()
/** 运动管理者对象 */
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravity;
@property (nonatomic,strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItem;
@end

@implementation motionViewController
- (CMMotionManager *)manager
{
    if (_manager == nil) {
        _manager = [[CMMotionManager alloc] init];
    }
    return _manager;
}
//懒加载物理仿真
-(UIDynamicAnimator *)animator{
    if(!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}
-(UIGravityBehavior *)gravity{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.2;
        // 添加到仿真器中开始仿真
        [self.animator addBehavior:_gravity];
    }
    return _gravity;
}
-(UICollisionBehavior *)collision{
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        _collision.collisionMode = UICollisionBehaviorModeEverything;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
        [_collision addBoundaryWithIdentifier:@"11" forPath:path];
        
        [self.animator addBehavior:_collision];
    }
    return _collision;
}
-(UIDynamicItemBehavior *)dynamicItem{   //物体属性 弹性 振幅
    if (!_dynamicItem) {
        _dynamicItem = [[UIDynamicItemBehavior alloc] init];
        _dynamicItem.elasticity = 0.4;
        [self.animator addBehavior:_dynamicItem];
    }
    return _dynamicItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color"]];
    self.imageView.frame = CGRectMake(0, 0, 100, 100);
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    [self.gravity addItem:self.imageView];
    [self.collision addItem:self.imageView];
    [self.dynamicItem addItem:self.imageView];
    

    NSArray *str = @[@"风",@"花",@"雪",@"月",@"反",@"杏",@"花",@"春",@"雨",@"戈"];
    for (NSInteger i = 0; i<str.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10+i*30, 10, 46, 46);
        label.text = str[i];
        label.font = [UIFont systemFontOfSize:46];
        [self.view addSubview:label];
        [self.gravity addItem:label];
        [self.collision addItem:label];
        [self.dynamicItem addItem:label];
    }
    
    NSArray *str2 = @[@"😍",@"😡",@"😊",@"😂",@"😲",@"🍉",@"❄️",@"😢",@"😭"];
    for (NSInteger i = 0; i<str2.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10+i*30, 60, 50, 50);
        label.layer.cornerRadius = 25;
        label.layer.masksToBounds = YES;
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.text = @"😏";   //ue057
        label.text = str2[i];
        label.font = [UIFont systemFontOfSize:46];
        [self.view addSubview:label];
        [self.gravity addItem:label];
        [self.collision addItem:label];
        [self.dynamicItem addItem:label];
    }
    
    [self setupMotion];
}

//-(NSString *)decodeUnicodeBytes:(char *)stringEncoded {
//    unsigned int    unicodeValue;
//    char            *p, buff[5];
//    NSMutableString *theString;
//    NSString        *hexString;
//    NSScanner       *pScanner;
//
//    theString = [[[NSMutableString alloc] init] autorelease];
//    p = stringEncoded;
//
//    buff[4] = 0x00;
//    while (*p != 0x00) {
//
//        if (*p == '\\') {
//            p++;
//            if (*p == 'u') {
//                memmove(buff, ++p, 4);
//
//                hexString = [NSString stringWithUTF8String:buff];
//                pScanner = [NSScanner scannerWithString: hexString];
//                [pScanner scanHexInt: &unicodeValue];
//
//                [theString appendFormat:@"%C", unicodeValue];
//                p += 4;
//                continue;
//            }
//        }
//
//        [theString appendFormat:@"%c", *p];
//        p++;
//    }
//
//    return [NSString stringWithString:theString];
//}

-(void)setupMotion
{
    // 1.判断陀螺仪是否可以用
    if (!self.manager.isGyroAvailable) {
        NSLog(@"");
        return;
    }
    
    // 2.设置采样间隔
    self.manager.gyroUpdateInterval = 1;
    // 3.开始采样

    __weak typeof(self) weakSelf = self;
    if ([self.manager isDeviceMotionAvailable]) {
        [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion,NSError * _Nullable error) {
            //获取这个然后使用这个角度进行view旋转，可以实现view保持水平的效果，设置一个图片可以测试
            double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
//            weakSelf.imageView.transform = CGAffineTransformMakeRotation(rotation);
            
            //2. Gravity 获取手机的重力值在各个方向上的分量，根据这个就可以获得手机的空间位置，倾斜角度等
            double gravityX = motion.gravity.x;
            double gravityY = motion.gravity.y;
            double gravityZ = motion.gravity.z;

            //获取手机的倾斜角度(zTheta是手机与水平面的夹角， xyTheta是手机绕自身旋转的角度)：
            double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
//            NSLog(@"%0.2f",zTheta);
            
            //加速度数据
            CMAcceleration acc = motion.userAcceleration;
            double accX = acc.x;
            double accY = acc.y;
            double accZ = acc.z;
            double zAcc = atan2(accZ,sqrtf(accX*accX+accY*accY))/M_PI*180.0;
            
//            NSLog(@" %0.2f",acc.x);
//            NSLog(@"加速计 x=%0.2f y=%0.2f z=%0.2f",acc.x,acc.y,acc.z);
            
            
//            double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
//            NSLog(@"%f   %f",fabs(90 + zTheta),xyTheta);
            weakSelf.gravity.magnitude = fabs(90 + zTheta) * 0.08;

            self.gravity.angle = rotation + M_PI_2;
        }];
    }
}

@end

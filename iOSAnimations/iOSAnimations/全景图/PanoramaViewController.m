//
//  PanoramaViewController.m
//  合集
//
//  Created by goat on 2019/6/12.
//  Copyright © 2019 goat. All rights reserved.
//

#import "PanoramaViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+Additions.h"

#define scrW [UIScreen mainScreen].bounds.size.width
#define scrH [UIScreen mainScreen].bounds.size.height
@interface PanoramaViewController ()<UICollisionBehaviorDelegate>
/** 运动管理者对象 */
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravity;
@property (nonatomic,strong) UICollisionBehavior *collision;
//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItem;

@property (nonatomic,strong) UIScrollView *scroll;
@property (nonatomic,assign) CGFloat distanceX;  //X方向分量
@property (nonatomic,assign) CGFloat distanceY;  //y方向分量
//
@property (nonatomic,strong) CAEmitterLayer *emitterLayer;
@property (nonatomic,strong) CAEmitterCell *cell;
@end

@implementation PanoramaViewController

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
        _collision.collisionDelegate = self;
        
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

-(UIScrollView *)scroll{
    if (_scroll == nil) {
        _scroll = [[UIScrollView alloc] init];
        _scroll.frame = CGRectMake(0,0, scrW, scrH);
        
        UIImage *image = [UIImage imageNamed:@"img48"];
        CGSize size = image.size;
        _scroll.contentSize = size;
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(0, 0, size.width, size.height);
        imageV.image = image;
        [_scroll addSubview:imageV];
        
        _scroll.contentOffset = CGPointMake((size.width-_scroll.bounds.size.width)/2, (size.height-_scroll.bounds.size.height)/2);
        
        self.distanceX = (size.width-_scroll.bounds.size.width)/2;
        self.distanceY = (size.height-_scroll.bounds.size.height)/2;
    }
    return  _scroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scroll];
    
    NSArray *str = @[@"风"];
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
    
    NSArray *str2 = @[@"😍",@"😡"];
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
    
    //添加按钮
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setTitle:@"添加" forState:UIControlStateNormal];
    add.titleLabel.font = [UIFont systemFontOfSize:30];
    [add addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
    add.frame = CGRectMake(scrW-100, scrH-50, 100, 30);
    [self.view addSubview:add];
    
    //栗子动画
    [self.view.layer addSublayer:self.emitterLayer];
}

-(void)touch{
    
    NSArray *str2 = @[@"😍",@"😡",@"😊",@"😂",@"😲",@"🍉",@"❄️",@"😢",@"😭"];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(scrW/2-20, 60, 50, 50);
    label.layer.cornerRadius = 25;
    label.layer.masksToBounds = YES;
    label.text = str2[random()%str2.count];
    label.font = [UIFont systemFontOfSize:46];
    [self.view addSubview:label];
    [self.gravity addItem:label];
    [self.collision addItem:label];
    [self.dynamicItem addItem:label];
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
            
            self.cell.yAcceleration = gravityY*10;
            self.cell.xAcceleration = gravityX*10;
            
            //scroll内容移动
            self.scroll.contentOffset = CGPointMake(self.distanceX-(gravityX*self.distanceX), self.distanceY+(gravityY*self.distanceY));
            
            //获取手机的倾斜角度(zTheta是手机与水平面的夹角， xyTheta是手机绕自身旋转的角度)：
            double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
            //            double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
            //            NSLog(@"%f   %f",fabs(90 + zTheta),xyTheta);
            weakSelf.gravity.magnitude = fabs(90 + zTheta) * 0.08;
            
            self.gravity.angle = rotation + M_PI_2;
        }];
    }
    
}


#pragma deleagte
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p{
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //震动太久
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2{
    
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p{
    
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier{
    
}

#pragma mark - 栗子动画
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(CAEmitterLayer *)emitterLayer{
    if (_emitterLayer == nil) {
        _emitterLayer = [CAEmitterLayer layer];
        //        _emitterLayer.borderColor = [UIColor redColor].CGColor;
        //        _emitterLayer.borderWidth = 1.f;
        _emitterLayer.position = CGPointMake(self.view.bounds.size.width, 0);
        _emitterLayer.emitterSize = self.view.bounds.size;
        _emitterLayer.emitterShape = kCAEmitterLayerCircle;
        _emitterLayer.emitterMode = kCAEmitterLayerLine;
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (__bridge id)([self createCircle].CGImage);
        
        emitterCell.birthRate = 20.f;
        emitterCell.lifetime = 10.f;
        emitterCell.velocity = 30.f;
        emitterCell.velocityRange = 60.f;
        emitterCell.yAcceleration = 15.f;
        
        emitterCell.emissionLongitude = M_PI;
        emitterCell.emissionRange = M_PI_4;
        
        emitterCell.scale = 0.1;
        emitterCell.scaleRange = 0.2;
        emitterCell.scaleSpeed = 0.02;
        
        //        emitterCell.color = [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:1.f].CGColor;
        emitterCell.color = [UIColor colorWithRed:.8f green:.8f blue:.8f alpha:1.f].CGColor;
        
        emitterCell.redRange = 1.f;
        emitterCell.greenRange = 1.f;
        emitterCell.blueRange = 1.f;
        
        emitterCell.alphaRange = .8f;
        emitterCell.alphaSpeed = -.1f;
        
        self.cell = emitterCell;
        
        _emitterLayer.emitterCells = @[emitterCell];
    }
    return _emitterLayer;
}


-(UIImage *)createCircle{
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    image = [self circleImage:image withParam:0];
    return image;
}

///把图片裁剪成圆形
//两个参数 image: 需要修改的图片
//inset: 内部偏移
-(UIImage *) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end

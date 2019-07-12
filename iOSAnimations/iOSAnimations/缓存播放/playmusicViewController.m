//
//  playmusicViewController.m
//  合集
//
//  Created by goat on 2017/12/28.
//  Copyright © 2017年 goat. All rights reserved.
//

#import "playmusicViewController.h"
#import "FreeStreamerPlayer.h"
#import "FSAudioStream.h"

@interface playmusicViewController ()<PlayerDelegate>
@property (nonatomic,strong) FreeStreamerPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISlider *progress;
@property (assign,nonatomic) BOOL isTouch;   //是否按住了进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;
@property (nonatomic,assign) NSInteger currentIndex;    //当前音乐下标
@property (weak, nonatomic) IBOutlet UILabel *playRate;
@property (weak, nonatomic) IBOutlet UISlider *playRateSilder;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UITextView *downloadList;

@end

@implementation playmusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = [FreeStreamerPlayer defaultPlayer];
    self.player.rate = 1.0;      //0.5   -   2
    self.player.playerDelegate = self;
    __weak typeof(self) weakSelf = self;
    self.player.onCompletion = ^{
        [weakSelf nextMusic:nil];
    };
    
    self.player.audioArray = [NSMutableArray arrayWithArray:@[    [NSURL URLWithString:@"http://47.92.221.199/new_tp/Uploads/2018-11-21/f04cb2644a1162d56d48.mp3"],
                                                              [NSURL URLWithString:@"http://47.92.221.199/new_tp/Uploads/2018-11-21/53ee10c1ff2f855819db.mp3"],
                                                              [NSURL URLWithString:@"http://47.92.221.199/new_tp/Uploads/2018-11-21/2009f609b23b4371338d.mp3"],
                                                              [NSURL URLWithString:@"http://47.92.221.199/new_tp/Uploads/2018-11-21/9c1811daf3b31b482939.mp3"],
                                                              [NSURL URLWithString:@"http://47.92.221.199/new_tp/Uploads/2018-11-21/9bf49fe7eff2cac8189c.mp3"]
                                                              ]];
    
    self.progress.continuous = NO;   //手指离开时置灰调用一次valueChange
    [self.progress addTarget:self action:@selector(ProgressTouchOutSide) forControlEvents:UIControlEventValueChanged];
    [self.progress addTarget:self action:@selector(progressTouchDown) forControlEvents:UIControlEventTouchDown];

    [self showDownloadList];
}


//上一首
- (IBAction)preMusic:(id)sender {
    if (self.currentIndex == 0) {
        self.currentIndex = self.player.audioArray.count - 1;
    }else{
        self.currentIndex --;
    }
    [self.player playItemAtIndex:self.currentIndex];
}
//下一首
- (IBAction)nextMusic:(id)sender {
    [self.player stop];
    self.currentIndex = (self.currentIndex+1)%self.player.audioArray.count;
    [self.player playItemAtIndex:self.currentIndex];
}
//暂停或开始
- (IBAction)playOrstop:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *str = [btn titleForState:UIControlStateNormal];
    if ([str isEqualToString:@"暂停"]) {
        [btn setTitle:@"开始" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
    }
    [self.player pause];
}

//清除缓存
- (IBAction)clearCache:(id)sender {
    [self.player expungeCache];
    self.cacheSize.text = [NSString stringWithFormat:@"缓存:%.01fMB",[self calculateachesSize]];
}
//计算缓存
- (IBAction)caculateCache:(id)sender {
    //缓存大小
    self.cacheSize.text = [NSString stringWithFormat:@"缓存:%.01fMB",[self calculateachesSize]];
}


- (IBAction)stop:(id)sender {
    [self.player stop];
}
- (IBAction)pasue:(id)sender {
    [self.player pause];
}
- (IBAction)play:(id)sender {
//    [self.player play];
    [self.player playItemAtIndex:2];
    self.currentIndex = 2;
}


//播放速率
- (IBAction)playRate:(id)sender {
    UISlider *silder = (UISlider *)sender;
    self.player.rate = silder.value;
    self.playRate.text = [NSString stringWithFormat:@"播放速率:%0.1f",silder.value];
}


-(void)ProgressTouchOutSide
{
    FSStreamPosition position = {0};
    position.position = self.progress.value;
    [self.player seekToPosition:position];     //取值范围0 - 1
    self.isTouch = NO;
}
-(void)progressTouchDown{
    self.isTouch = YES;
}

//流是否连续
- (IBAction)isContious:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:[NSString stringWithFormat:@"流是否连续 %d",self.player.continuous] forState:UIControlStateNormal];
}

//音量大小
- (IBAction)value:(id)sender {
    UISlider *silder = (UISlider *)sender;
    self.player.volume = silder.value;
    self.volumeLabel.text = [NSString stringWithFormat:@"音量大小:%.01f",silder.value];
}

//下载
- (IBAction)download:(id)sender {
    NSURL *url = self.player.audioArray[self.currentIndex];
    NSArray *array = [url.absoluteString componentsSeparatedByString:@"/"];
    NSString *filePath = [self.player.configuration.cacheDirectory stringByAppendingPathComponent:[array lastObject]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    self.player.outputFile = [NSURL fileURLWithPath:filePath];
    
    //显示已下载内容
    [self showDownloadList];
}

-(void)showDownloadList
{
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.player.configuration.cacheDirectory error:nil];
    NSString *str = @"已下载的歌曲：";
    for (NSString *file in fileArray) {
        if ([file containsString:@".mp3"]) {
            str = [NSString stringWithFormat:@"%@\n%@",str,file];
        }
    }
    self.downloadList.text = str;
}


#pragma mark - 代理
-(void)updateProgressWithCurrentPosition:(FSStreamPosition)currentPosition andEndPosition:(FSStreamPosition)endPosition
{
    NSLog(@"当前播放时长 = %u:%u %.02f秒 %.02f",currentPosition.minute,currentPosition.second,currentPosition.playbackTimeInSeconds,currentPosition.position);
    
    NSLog(@"总时间 = %u:%u %.02f秒",endPosition.minute,endPosition.second,endPosition.playbackTimeInSeconds);
    self.currentLabel.text = [NSString stringWithFormat:@"%02u:%02u",currentPosition.minute,currentPosition.second];
    self.totalLabel.text = [NSString stringWithFormat:@"%02u:%02u",endPosition.minute,endPosition.second];
    if (self.isTouch == NO) {
        //播放进度
        self.progress.value = currentPosition.position;
    }
    
    //缓存进度
    float prebuffer = (float)self.player.prebufferedByteCount;
    float contentlength = (float)self.player.contentLength;
    if (contentlength>0) {
        self.progressView.progress = prebuffer/contentlength;
    }
    
}


//获取缓存大小
- (CGFloat)calculateachesSize {
    
    float totalCacheSize = 0;
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.player.configuration.cacheDirectory error:nil];
    for (NSString *file in fileArray) {
        if ([file hasPrefix:@"FSCache-"]) {
      
            NSString *filePath = [self.player.configuration.cacheDirectory stringByAppendingPathComponent:file];
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            unsigned long long length = [fileAttributes fileSize];
            float ff = length/1024.0/1024.0;
            totalCacheSize += ff;
        }
    }
    return totalCacheSize;
}

//无论有没有播放歌曲都会成功释放
-(void)dealloc
{
    
}
@end

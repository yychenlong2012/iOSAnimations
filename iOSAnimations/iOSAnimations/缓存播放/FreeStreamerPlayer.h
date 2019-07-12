//
//  FreeStreamerPlayer.h
//  合集
//
//  Created by goat on 2017/12/28.
//  Copyright © 2017年 goat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAudioStream.h"

@protocol PlayerDelegate <NSObject>

@optional
/**
 *  更新播放进度
 *
 *  @param currentPosition 当前位置
 *  @param endPosition     结束位置（总时长）
 */
- (void)updateProgressWithCurrentPosition:(FSStreamPosition)currentPosition andEndPosition:(FSStreamPosition)endPosition;

//播放完毕
- (void)playCompletion;
@end

@interface FreeStreamerPlayer : FSAudioStream

/**
 *  是否为播放状态
 */
@property (assign, nonatomic) BOOL isPlay;
/**
 *  是否循环播放
 */
@property (assign, nonatomic) BOOL isLoop;
/**
 *  播放文件地址(队列)数组
 */
@property (strong, nonatomic) NSMutableArray * audioArray;
/**
 *  播放速率
 */
@property (assign, nonatomic) float rate;

@property (assign, nonatomic) BOOL isSinglePlay;
/**
 *  代理 用于更新播放进度
 */
@property (weak, nonatomic) id<PlayerDelegate> playerDelegate;

/**
 *  获得播放器单例
 *
 *  @return 获得播放器单例
 */
+ (instancetype)defaultPlayer;

/**
 *  播放文件队列中的指定文件
 *
 *  @param itemIndex 指定的文件的索引
 */
- (void)playItemAtIndex:(NSUInteger)itemIndex;

@end  

//
//  AudioPlayDelegate.h
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioPlayDelegate <NSObject>

@optional

- (void)audioPlayDidStarted:(id)userinfo;

//播放录音时，系统声音太小
- (void)audioPlayVolumeTooLow;

//发生播放错误时，播放Session同时结束
- (void)audioPlayDidFailed:(id)userinfo;

//播放结束时考虑到连续播放的需求，仅仅停止了当前播放，没有
//停止播放session
- (void)audioPlayDidFinished:(id)userinfo;

//播放停止时考虑到连续播放的需求，仅仅停止了当前播放，没有
//停止播放session
- (void)audioPlayDidStopped:(id)userinfo;

@end

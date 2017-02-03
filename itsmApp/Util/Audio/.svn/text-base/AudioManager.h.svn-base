//
//  AudioManager.h
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRecordDelegate.h"
#import "AudioPlayDelegate.h"
@import AVFoundation;

typedef NS_ENUM(NSInteger, ErrorRecordType) {
    kErrorRecordTypeAuthorizationDenied,
    kErrorRecordTypeInitFailed,
    kErrorRecordTypeCreateAudioFileFailed,
    kErrorRecordTypeMultiRequest,
    kErrorRecordTypeRecordError,
};

typedef NS_ENUM(NSInteger, ErrorPlayType) {
    kErrorPlayTypeInitFailed = 0,
    kErrorPlayTypeFileNotExist,
    kErrorPlayTypePlayError,
};

//录音需要的最短时间
#define MIN_RECORD_TIME_REQUIRED 1

//录音允许的最长时间
#define MAX_RECORD_TIME_ALLOWED 60


@interface AudioManager : NSObject

@property (nonatomic) BOOL isRecording;

@property (nonatomic) BOOL isPlaying;


+ (instancetype)sharedManager;

- (void)startRecordingWithDelegate:(id<AudioRecordDelegate>)delegate;

- (void)stopRecording;

- (void)cancelRecording;

- (void)requestRecordPermission:(void (^)(AVAudioSessionRecordPermission recordPermission))callback;

- (void)startPlayingWithPath:(NSString *)aFilePath
                        delegate:(id<AudioPlayDelegate>)delegate
                        userinfo:(id)userinfo
                 continuePlaying:(BOOL)continuePlaying;

//关闭整个播放Session
- (void)stopPlaying;

//仅仅停止当前文件的播放，不关闭Session
- (void)stopCurrentPlaying;

+ (void)clearnAudioRecordCache;

@end

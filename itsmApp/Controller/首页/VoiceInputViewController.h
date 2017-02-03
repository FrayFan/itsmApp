//
//  VoiceInputViewController.h
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioManager.h"

@class VoiceInputViewController;

@protocol VoiceInputDelegate <NSObject>

- (void)voiceInputDidHide:(VoiceInputViewController *)controller;

- (void)voiceRecordingShouldStart;

- (void)voiceRecordingShouldCancel;

- (void)voicRecordingShouldFinish;

- (void)voiceRecordingDidDraginside;

- (void)voiceRecordingDidDragoutside;

- (void)voiceRecordingTooShort;

@end

@interface VoiceInputViewController : UIViewController

@property (weak, nonatomic)id<VoiceInputDelegate> delegate;

- (void)cancelRecordButtonTouchEvent;

@end

//
//  VoiceInputViewController.m
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "VoiceInputViewController.h"
#import "UIColor+HEX.h"
#import "AudioManager.h"
#import "EMMLog.h"

static int emmLogLevel = EMMLogLevelOff;

@interface VoiceInputViewController ()
{
    CFTimeInterval touchDownTime;
    dispatch_block_t block;
}
@property (nonatomic) BOOL recordPermissionGranted;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

- (IBAction)closeAction:(id)sender;

@end

@implementation VoiceInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(voiceInputDidHide:)]) {
        [self.delegate voiceInputDidHide:self];
    }
    
}

- (IBAction)recordButtonTouchDown:(id)sender {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    __weak typeof(self) weakSelf = self;

    [[AudioManager sharedManager] requestRecordPermission:^(AVAudioSessionRecordPermission recordPermission) {
        if (recordPermission == AVAudioSessionRecordPermissionGranted) {
            weakSelf.recordPermissionGranted = YES;
            [weakSelf setRecordButtonBackground:YES];
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->touchDownTime = CACurrentMediaTime();
            if ([weakSelf.delegate respondsToSelector:@selector(voiceRecordingShouldStart)]) {
                strongSelf->block = dispatch_block_create(0, ^{
                    [weakSelf setRecordButtonTitle:YES];
                    [weakSelf.delegate voiceRecordingShouldStart];
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), strongSelf->block);
            }

        }
    }];
    
}

- (IBAction)recordButtonTouchUpinside:(id)sender {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (!self.recordPermissionGranted)
        return;
    
    CFTimeInterval currentTime = CACurrentMediaTime();
    if (currentTime - touchDownTime < MIN_RECORD_TIME_REQUIRED + 0.25) {
        
        self.recordButton.enabled = NO;
        if (!dispatch_block_testcancel(block))
            dispatch_block_cancel(block);
        block = nil;
        
        if ([self.delegate respondsToSelector:@selector(voiceRecordingTooShort)]) {
            [self.delegate voiceRecordingTooShort];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MIN_RECORD_TIME_REQUIRED * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.recordButton.enabled = YES;
            [self recordActionEnd];
        });
        
    }else {
        
        [self recordActionEnd];
        if ([self.delegate respondsToSelector:@selector(voicRecordingShouldFinish)]) {
            [self.delegate voicRecordingShouldFinish];
        }
    }
    
}

- (IBAction)recordButtonTouchUpoutside:(id)sender {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (!self.recordPermissionGranted)
        return;
    
    [self recordActionEnd];
    
    if ([self.delegate respondsToSelector:@selector(voiceRecordingShouldCancel)]) {
        [self.delegate voiceRecordingShouldCancel];
    }
    
}

- (IBAction)recordButtonTouchCancelled:(id)sender {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (!self.recordPermissionGranted)
        return;
    
    [self recordButtonTouchUpinside:sender];
}

- (void)cancelRecordButtonTouchEvent {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [self.recordButton cancelTrackingWithEvent:nil];
    [self recordActionEnd];
}

- (IBAction)recordButtonDragEnter:(id)sender {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (!self.recordPermissionGranted)
        return;
    
    if ([self.delegate respondsToSelector:@selector(voiceRecordingDidDraginside)]) {
        [self.delegate voiceRecordingDidDraginside];
    }
}

- (IBAction)recordButtonDragExit:(id)sender {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (!self.recordPermissionGranted)
        return;
    
    if ([self.delegate respondsToSelector:@selector(voiceRecordingDidDragoutside)]) {
        [self.delegate voiceRecordingDidDragoutside];
    }
}

- (void)recordActionEnd {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [self setRecordButtonTitle:NO];
    [self setRecordButtonBackground:NO];
}

- (void)setRecordButtonBackground:(BOOL)isRecording {
//    if (isRecording) {
//        self.recordButton.backgroundColor = [UIColor getColor:@"#C6C7CB"];
//    }else {
//        self.recordButton.backgroundColor = [UIColor getColor:@"#F3F4F8"];
//    }
}

- (void)setRecordButtonTitle:(BOOL)isRecording {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (isRecording) {
        [self.recordButton setTitle:@"松开 结束" forState:UIControlStateNormal];
    }else {
        [self.recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    }
}

@end

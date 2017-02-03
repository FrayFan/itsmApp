//
//  VoiceIndicatorViewController.m
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "VoiceIndicatorViewController.h"

#define kVoiceNoteText_ToRecord @"手指上滑，取消发送"
#define kVoiceNoteText_ToCancel @"松开手指，取消发送"
#define kVoiceNoteText_TooShort @"说话时间太短"
#define kVoiceNoteText_TooLong @"说话时间超长"
#define kVoiceNoteText_VolumeTooLow @"请调大音量后播放"

#define ImageNamed_Cancel @"RecordCancel"
#define ImageNamed_TimeTooShortOrLong @"MessageTooShort"
#define ImageNamed_VolumeTooLow @"volume_smalltipsicon"

@interface VoiceIndicatorViewController ()

@property (weak, nonatomic) IBOutlet UIView *recordingView;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *signalImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation VoiceIndicatorViewController

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

- (void)setStyle:(VoiceIndicatorStyle)style {
    _style = style;
    self.infoImageView.hidden = YES;
    self.recordingView.hidden = YES;
    [self updateMetersValue:0];
    
    switch (style) {
        case kVoiceIndicatorStyleRecord:
            self.label.backgroundColor = [UIColor clearColor];
            self.label.text = kVoiceNoteText_ToRecord;
            self.recordingView.hidden = NO;
            break;
        case kVoiceIndicatorStyleCancel:
            self.label.backgroundColor = [UIColor colorWithRed:156/255.0 green:54/255.0 blue:56/255.0 alpha:1];
            self.label.text = kVoiceNoteText_ToCancel;
            self.infoImageView.hidden = NO;
            self.infoImageView.image = [UIImage imageNamed:ImageNamed_Cancel];
            break;
        case kVoiceIndicatorStyleTooShort:
            self.label.backgroundColor = [UIColor clearColor];
            self.label.text = kVoiceNoteText_TooShort;
            self.infoImageView.hidden = NO;
            self.infoImageView.image = [UIImage imageNamed:ImageNamed_TimeTooShortOrLong];
            break;
        case kVoiceIndicatorStyleTooLong:
            self.label.backgroundColor = [UIColor clearColor];
            self.label.text = kVoiceNoteText_TooLong;
            self.infoImageView.hidden = NO;
            self.infoImageView.image = [UIImage imageNamed:ImageNamed_TimeTooShortOrLong];
            break;
        case kVoiceIndicatorStyleVolumeTooLow:
            self.label.backgroundColor = [UIColor clearColor];
            self.label.text = kVoiceNoteText_VolumeTooLow;
            self.infoImageView.hidden = NO;
            self.infoImageView.image = [UIImage imageNamed:ImageNamed_VolumeTooLow];
            break;
            
    }
}

//更新麦克风的音量大小
- (void)updateMetersValue:(CGFloat)value {
    NSInteger index = round(value);
    index = index > 8 ? 8 : index;
    index = index < 1 ? 1 : index;
    
    NSString *imageName = [NSString stringWithFormat:@"RecordingSignal00%ld", (long)index];
    self.signalImageView.image = [UIImage imageNamed:imageName];
    
}


@end

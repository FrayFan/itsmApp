//
//  VoiceTableViewCell.m
//  itsmApp
//
//  Created by itp on 2016/11/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "VoiceTableViewCell.h"
#import "VoicePlayView.h"
#import "AudioManager.h"

@interface VoiceTableViewCell ()
{
    
}
@property (weak, nonatomic) IBOutlet VoicePlayView *voicePlayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voicePlayWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)deleteVoiceAction:(id)sender;

@end

@implementation VoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDelegate:(id<VoiceTableViewCellDelegate>)delegate
{
    _delegate = delegate;
    self.voicePlayView.delegate = delegate;
}

- (void)showVoiceRecord:(NSString *)duration
{
    self.voicePlayView.duration = duration;
    
    [self showVoicePlayView];
}

- (IBAction)recordAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(startRecordVoice)]) {
        [self.delegate startRecordVoice];
    }
}

- (void)showVoicePlayView
{
    self.voicePlayView.hidden = NO;
    self.closeButton.hidden = NO;
    self.closeImageView.hidden = NO;
}

- (void)hideVoiceRecord
{
    self.voicePlayView.hidden = YES;
    self.closeButton.hidden = YES;
    self.closeImageView.hidden = YES;
}

- (IBAction)deleteVoiceAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteVoiceRecord)]) {
        [self.delegate deleteVoiceRecord];
    }
}

- (void)stopVoiceAnimation
{
    self.voicePlayView.voiceAnimation = NO;
}

@end

//
//  VoicePlayView.m
//  itsmApp
//
//  Created by itp on 2016/12/14.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "VoicePlayView.h"

@interface VoicePlayView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@end

@implementation VoicePlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFromXib];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupFromXib];
    }
    return self;
}

- (void)setupFromXib
{
    [[NSBundle mainBundle] loadNibNamed:@"VoicePlayView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    _voiceImageView.animationImages = @[[UIImage imageNamed:@"VoiceNodePlaying001"],
                                        [UIImage imageNamed:@"VoiceNodePlaying002"],
                                        [UIImage imageNamed:@"VoiceNodePlaying003"]];
    _voiceImageView.animationDuration = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDuration:(NSString *)duration
{
    if (_duration == duration) {
        return;
    }
    _duration = [duration copy];
    _durationLabel.text = [NSString stringWithFormat:@"%@\"",_duration ?:@"0"];
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(voiceDidPlay:)]) {
        self.voiceAnimation = !self.voiceAnimation;
        [self.delegate voiceDidPlay:self.voiceAnimation];
    }
}

- (void)setVoiceAnimation:(BOOL)voiceAnimation
{
    _voiceAnimation = voiceAnimation;
    if (_voiceAnimation) {
        [_voiceImageView startAnimating];
    }
    else
    {
        [_voiceImageView stopAnimating];
    }
}

@end

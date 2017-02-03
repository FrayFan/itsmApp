//
//  VoiceTableViewCell.h
//  itsmApp
//
//  Created by itp on 2016/11/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoicePlayView.h"

@protocol VoiceTableViewCellDelegate <VoicePlayDelegate>

@optional

- (void)startRecordVoice;

- (void)playVoice:(BOOL)play;

- (void)deleteVoiceRecord;

@end

@interface VoiceTableViewCell : UITableViewCell

@property (weak, nonatomic)id<VoiceTableViewCellDelegate> delegate;

- (void)showVoiceRecord:(NSString *)duration;

- (void)hideVoiceRecord;

- (void)stopVoiceAnimation;

@end

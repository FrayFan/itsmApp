//
//  VoicePlayView.h
//  itsmApp
//
//  Created by itp on 2016/12/14.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoicePlayDelegate <NSObject>

@optional

- (void)voiceDidPlay:(BOOL)play;

@end

@interface VoicePlayView : UIView

@property (weak,nonatomic) IBOutlet id<VoicePlayDelegate> delegate;

@property (nonatomic,copy) NSString *duration;

@property (nonatomic,assign) BOOL voiceAnimation;

@end

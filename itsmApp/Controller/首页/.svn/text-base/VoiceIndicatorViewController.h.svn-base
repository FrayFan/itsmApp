//
//  VoiceIndicatorViewController.h
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VoiceIndicatorStyle) {
    kVoiceIndicatorStyleRecord = 0,
    kVoiceIndicatorStyleCancel,
    kVoiceIndicatorStyleTooShort,
    kVoiceIndicatorStyleTooLong,
    kVoiceIndicatorStyleVolumeTooLow
};

@interface VoiceIndicatorViewController : UIViewController
@property (nonatomic) VoiceIndicatorStyle style;

- (void)updateMetersValue:(CGFloat)value;

@end

//
//  TimerPickerViewController.h
//  itsmApp
//
//  Created by itp on 2016/12/5.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerPickerViewController;

@protocol TimerPickerDelegate <NSObject>

- (void)timerPicker:(TimerPickerViewController *)controller finished:(BOOL)finished;

@end

@interface TimerPickerViewController : UIViewController
@property (strong, nonatomic)NSDate *selectedDate;
@property (weak,nonatomic)id<TimerPickerDelegate> delegate;

@end

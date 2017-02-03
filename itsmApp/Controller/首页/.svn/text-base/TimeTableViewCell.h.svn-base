//
//  TimeTableViewCell.h
//  itsmApp
//
//  Created by itp on 2016/11/25.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeTableViewCellDelegate <NSObject>

@optional

- (void)selectedTime;

@end

@interface TimeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) id<TimeTableViewCellDelegate> delegate;

@end

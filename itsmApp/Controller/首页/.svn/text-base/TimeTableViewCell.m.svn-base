//
//  TimeTableViewCell.m
//  itsmApp
//
//  Created by itp on 2016/11/25.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)timeSelectedAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedTime)]) {
        [self.delegate selectedTime];
    }
    
}

@end

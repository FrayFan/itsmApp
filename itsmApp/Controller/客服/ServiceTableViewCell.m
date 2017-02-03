//
//  ServiceTableViewCell.m
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ServiceTableViewCell.h"
#import "common.h"

@implementation ServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setFrame:(CGRect)frame
{
    CGRect cellFrame = frame;
    cellFrame.size.height -= HProportion;
    frame = cellFrame;
    [super setFrame:frame];
    
}

@end

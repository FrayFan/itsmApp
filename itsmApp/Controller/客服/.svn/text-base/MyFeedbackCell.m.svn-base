//
//  MyFeedbackCell.m
//  itsmApp
//
//  Created by admin on 2016/12/25.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "MyFeedbackCell.h"
#import "common.h"

@interface MyFeedbackCell ()
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end

@implementation MyFeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setFrame:(CGRect)frame
{
    if (_listCell) {
        CGRect cellFrame = frame;
        cellFrame.size.height -= HProportion;
        frame = cellFrame;
    }
    [super setFrame:frame];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFeedBackModel:(MyFeedbackModel *)feedBackModel
{
    _feedBackModel = feedBackModel;
    _date.text = _feedBackModel.createTime;
    _status.text = _feedBackModel.processStatus;
    _content.text = _feedBackModel.adviceContent;
    
    
}



@end

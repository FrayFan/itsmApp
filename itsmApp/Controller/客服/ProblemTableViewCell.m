//
//  ProblemTableViewCell.m
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ProblemTableViewCell.h"
#import "UIView+Additions.h"
#import "common.h"

#define HProportion (8.0/667.0)*([[UIScreen mainScreen] bounds].size.height)

@interface ProblemTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderContent;
@property (weak, nonatomic) IBOutlet UILabel *createTime;



@end

@implementation ProblemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UILabel *appealLable = [self viewWithTag:333];
    appealLable.layer.cornerRadius = 5;
    appealLable.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _scrollTextView = [[LMJScrollTextView alloc] initWithFrame:CGRectMake(15, _orderContent.bottom+10, KScreenWidth-155, 13) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    [self addSubview:_scrollTextView];
}

-(void)setFrame:(CGRect)frame
{
    CGRect cellFrame = frame;
    cellFrame.size.height -= HProportion;
    frame = cellFrame;
    [super setFrame:frame];

    
}

-(void)setOrderModel:(OrdersModel *)orderModel
{
    _orderModel = orderModel;
    
    _orderNumber.text = orderModel.receiptId;
    _orderStatus.text = orderModel.ticketStatus;
    _orderContent.text = orderModel.content;
    
//    if (_orderModel.engineerModel.engineerName != nil) {
//        
//        [_scrollTextView startScrollWithText:[NSString stringWithFormat:@"%@ %@ %@",_orderModel.engineerModel.engineerDept,_orderModel.engineerModel.engineerName,_orderModel.engineerModel.engineerPhone] textColor:GrayColor font:[UIFont systemFontOfSize:13]];
//    }else{
//        _scrollTextView = nil;
//    }

    if ([_orderModel.type isEqualToString:@"01"]) {
        _createTime.text = orderModel.createTime;
    }else{
        _createTime.text = _orderModel.subscribeTime;
    }
    
    
}



@end

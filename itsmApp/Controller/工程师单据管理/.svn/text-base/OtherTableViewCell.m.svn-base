//
//  OtherTableViewCell.m
//  itsmApp
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "OtherTableViewCell.h"

@interface OtherTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *category;

@end

@implementation OtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    CGRect cellFrame = frame;
    cellFrame.size.height -= 8;
    frame = cellFrame;
    [super setFrame:frame];
    
}

-(void)setOrderModel:(OrdersModel *)orderModel
{
    _orderModel = orderModel;
    _orderNumber.text = _orderModel.receiptId;
    _userTel.text = [NSString stringWithFormat:@"%@ %@",_orderModel.userName,_orderModel.userPhone];
    _content.text = _orderModel.content;
    
    if ([_orderModel.type isEqualToString:@"01"]) {
        _date.text = _orderModel.createTime;
    }else{
        _date.text = _orderModel.subscribeTime;
    }
    
    if (![_orderModel.category1 isEqualToString:@""]||
        ![_orderModel.category2 isEqualToString:@""]) {
        _category.text = [NSString stringWithFormat:@"%@-%@",_orderModel.category1,_orderModel.category2];
    }else{
        _category.text = @"";
    }
}



@end

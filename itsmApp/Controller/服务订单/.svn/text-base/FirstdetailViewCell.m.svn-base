//
//  FirstdetailViewCell.m
//  itsmApp
//
//  Created by admin on 2016/11/30.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "FirstdetailViewCell.h"

@interface FirstdetailViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *content;


@end

@implementation FirstdetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFirstDetailModel:(DetailModel*)firstDetailModel
{
    _firstDetailModel = firstDetailModel;
    
    _orderNumber.text = _firstDetailModel.receiptId;
    
    if ([_firstDetailModel.type isEqualToString:@"01"]) {
        _date.text = _firstDetailModel.createTime;
    }else{
        _date.text = _firstDetailModel.subscribeTime;
    }
    
    _content.text = _firstDetailModel.content;
    
    if (![_firstDetailModel.category1 isEqualToString:@""]||
        ![_firstDetailModel.category2 isEqualToString:@""]) {
            _category.text = [NSString stringWithFormat:@"%@-%@",_firstDetailModel.category1,_firstDetailModel.category2];
        
        if (![_firstDetailModel.category3 isEqualToString:@""]) {
            _category.text = [NSString stringWithFormat:@"%@-%@-%@",_firstDetailModel.category1,_firstDetailModel.category2,_firstDetailModel.category3];
        }
        
    }
    
    if (_firstDetailModel == nil) {
        _category.text = @"";
    }
    
}



@end

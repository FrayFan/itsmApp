//
//  ServiceOrderTableCell.m
//  itsmApp
//
//  Created by admin on 2016/11/21.
//  Copyright © 2016年 itp. All rights reserved.
//


#import "ServiceOrderTableCell.h"
#import "UIView+ViewController.h"
#import "UIImage+Image.h"
#import "UIView+Additions.h"
#import "AssessmentController.h"
#import "UIImageView+WebCache.h"

#define HProportion (8.0/667.0)*([[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ServiceOrderTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;//服务信息
@property (weak, nonatomic) IBOutlet UILabel *date;//处理时间
@property (weak, nonatomic) IBOutlet UILabel *currentPro;//当前进展
@property (weak, nonatomic) IBOutlet UILabel *nextStep;//下一步
@property (weak, nonatomic) IBOutlet UIImageView *sourceImage;
@property (weak, nonatomic) IBOutlet UILabel *progress;//进展情况

@end

@implementation ServiceOrderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _CommentButton.tag = 1000;
    _CommentButton.layer.cornerRadius = 15;
    _CommentButton.layer.masksToBounds = YES;
    _CommentButton.layer.borderWidth = 1;
    _CommentButton.layer.borderColor = [UIColor colorWithRed:7/225.0 green:183/225.0 blue:243/225.0 alpha:1].CGColor;
    
    _descriptionText.numberOfLines = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

-(void)setFrame:(CGRect)frame
{
    CGRect cellFrame = frame;
    cellFrame.size.height -= HProportion;
    frame = cellFrame;
    [super setFrame:frame];
}

- (void)setSourceState:(BOOL)sourceState{
    _sourceState = sourceState;
    
    if (self.sourceState) {
        self.rightConstaint.constant = 15;
    }else {
        self.rightConstaint.constant = 75;
    }

}


-(void)setOrdersModel:(OrdersModel *)ordersModel
{
    _ordersModel = ordersModel;
    
    
    _descriptionText.text = _ordersModel.content;
    _userTel.text = [NSString stringWithFormat:@"%@ %@",_ordersModel.engineerModel.engineerName,_ordersModel.engineerModel.engineerPhone];
    
    if ([_ordersModel.type isEqualToString:@"01"]) {
        _date.text = _ordersModel.createTime;
    }else{
        _date.text = _ordersModel.subscribeTime;
    }
    
    _currentPro.text = [NSString stringWithFormat:@"当前进展:%@",_ordersModel.currentStage];
    _nextStep.text = [NSString stringWithFormat:@"下一步:%@",_ordersModel.nextStage];
    
    if ([_ordersModel.orginalType isEqualToString:@"IT网站"]) {
        
        _sourceImage.image = [UIImage imageNamed:@"ie_browse_picture"];
    }else if ([_ordersModel.orginalType isEqualToString:@"手机APP"]){
        
        _sourceImage.image = [UIImage imageNamed:@"app_picture"];
    }else{
        _sourceImage.image = [UIImage imageNamed:@"hotline_picture"];
    }
        
    _orderSource.text = _ordersModel.orginalType;
    
    _progress.text = _ordersModel.ticketStatus;
    if ([_ordersModel.ticketStatus isEqualToString:@"已提交"]||[_ordersModel.ticketStatus isEqualToString:@"已关闭"]) {
        _progress.textColor = RedColor;
        
    }else if ([_ordersModel.ticketStatus isEqualToString:@"已完成"]){
        _progress.textColor = GreenColor;
    }else if ([_ordersModel.ticketStatus isEqualToString:@"已取消"]||[_ordersModel.ticketStatus isEqualToString:@"暂停服务"]){
        _progress.textColor = GrayColor;
    }else if ([_ordersModel.ticketStatus isEqualToString:@"进行中"]){
        _progress.textColor = BlueColor;
    }
    
    _icon.layer.cornerRadius = _icon.height/2;
    _icon.layer.masksToBounds = YES;
    if (_ordersModel.engineerModel.engineerHeadImg != nil) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:_ordersModel.engineerModel.engineerHeadImg] placeholderImage:[UIImage imageNamed:@"default_header"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                _icon.image = [UIImage imageNamed:@"default_header"];
            }
        }];
        
    }else{
        _icon.image = [UIImage imageNamed:@"default_header"];
    }

        
}


@end

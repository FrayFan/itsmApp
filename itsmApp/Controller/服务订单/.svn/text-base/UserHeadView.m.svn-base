//
//  UserHeadView.m
//  itsmApp
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "UserHeadView.h"
#import "UIImageView+WebCache.h"
#import "LMJScrollTextView.h"
#import "AppealViewController.h"
#import "UIView+ViewController.h"

@interface UserHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (strong,nonatomic) LMJScrollTextView *scrollTextView;
@property (weak, nonatomic) IBOutlet UIButton *complainButton;
- (IBAction)complainAction:(id)sender;


@end


@implementation UserHeadView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _scrollTextView = [[LMJScrollTextView alloc]initWithFrame:CGRectMake(85, 55, KScreenWidth-100, 19) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        [self addSubview:_scrollTextView];
        
        UIButton *complainButton = [self viewWithTag:555];
        complainButton.layer.cornerRadius = 10;
        complainButton.layer.masksToBounds = YES;
        
    }
    return self;
}

-(void)setOrderModel:(OrdersModel *)orderModel
{
    _orderModel = orderModel;
    _userIcon.layer.cornerRadius = _userIcon.frame.size.width/2;
    _userIcon.layer.masksToBounds = YES;
    
    if (![_orderModel.engineerModel.engineerName isEqualToString:@""]) {
        if (![_orderModel.engineerModel.engineerHeadImg isEqualToString:@""]) {
            [_userIcon sd_setImageWithURL:[NSURL URLWithString:_orderModel.engineerModel.engineerHeadImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    _userIcon.image = [UIImage imageNamed:@"default_header"];
                }
            }];
        }else{
            _userIcon.image = [UIImage imageNamed:@"default_header"];
        }

    }

    _userTel.text = [NSString stringWithFormat:@"%@ %@",_orderModel.engineerModel.engineerName,_orderModel.engineerModel.engineerPhone];

    [_scrollTextView startScrollWithText:_orderModel.engineerModel.skill textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:19]];
    
    if (![_orderModel.complainTime isEqualToString:@""]||
        (![_orderModel.ticketStatus isEqualToString:@"已提交"]&&
         ![_orderModel.ticketStatus isEqualToString:@"进行中"]&&
         ![_orderModel.ticketStatus isEqualToString:@"已完成"])||
        ![_orderModel.orginalType isEqualToString:@"手机APP"]) {
        
        _complainButton.hidden = YES;
    }
    
    [self reloadInputViews];
}




- (IBAction)complainAction:(id)sender {
    
    AppealViewController *appealVC = [[NSBundle mainBundle] loadNibNamed:@"AppealViewController" owner:nil options:nil].lastObject;

    appealVC.orderModel = _orderModel;
    [self.viewController.navigationController pushViewController:appealVC animated:YES];
}




@end

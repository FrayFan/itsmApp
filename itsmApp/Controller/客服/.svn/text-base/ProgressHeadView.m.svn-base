//
//  ProgressHeadView.m
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ProgressHeadView.h"
#import "LMJScrollTextView.h"
#import "UIView+Additions.h"
#import "common.h"

@interface ProgressHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *orderID;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (strong,nonatomic) LMJScrollTextView *scrollTextView;

@end

@implementation ProgressHeadView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _button = [self viewWithTag:222];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _scrollTextView = [[LMJScrollTextView alloc]initWithFrame:CGRectMake(15, 97, KScreenWidth-150, 13) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        [self addSubview:_scrollTextView];
        
    }
    return self;
}

- (void)buttonAction:(UIButton *)button
{
    [self.delegate openProgressViewForSection:_button.tag];
    
}

-(void)setButton:(UIButton *)button
{
    _button = button;
    
}

-(void)setComplainModel:(ComplainModel *)complainModel
{
    _complainModel = complainModel;
    
    _orderID.text = _complainModel.receiptId;
    _content.text = _complainModel.content;
    
    if (_complainModel.engineerModel.engineerName != nil) {
        
        [_scrollTextView startScrollWithText:[NSString stringWithFormat:@"%@ %@ %@",_complainModel.engineerModel.engineerDept,_complainModel.engineerModel.engineerName,_complainModel.engineerModel.engineerPhone] textColor:GrayColor font:[UIFont systemFontOfSize:13]];
    }else{
        _scrollTextView = nil;
    }
    _date.text = _complainModel.complainTime;
    
    _status.text = @"投诉进度查询";
    
}


@end

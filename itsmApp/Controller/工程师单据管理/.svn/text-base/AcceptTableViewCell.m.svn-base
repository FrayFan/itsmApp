//
//  AcceptTableViewCell.m
//  itsmApp
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "AcceptTableViewCell.h"
#import "UIView+ViewController.h"
#import "GetCreateRPHandle.h"
#import "GetOrdersHandle.h"
#import "GraycoverPromptView.h"
#import "BillsViewController.h"
#import "MBProgressHUD.h"

@interface AcceptTableViewCell ()<NetworkHandleDelegate>

@property (strong,nonatomic) GetCreateRPHandle *createRPHandle;
@property (strong,nonatomic) GetOrdersHandle *orderHandle;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (assign,nonatomic) NSInteger oneTime;

- (IBAction)contactedAction:(id)sender;//已联系

@end


@implementation AcceptTableViewCell
{
    MBProgressHUD *HUDView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddAcceptedPrompt" object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _contactedButton.layer.cornerRadius = 5;
    _contactedButton.layer.masksToBounds = YES;
    
    HUDView = [[MBProgressHUD alloc]init];
    HUDView.labelText = @"正在加载";
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

- (IBAction)contactedAction:(UIButton *)sender {
    
    [self.viewController.view addSubview:HUDView];
    [HUDView show:YES];
    
    //发送已受理状态更改请求
    _createRPHandle = [[GetCreateRPHandle alloc]init];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_createRPHandle.requestObj.d];
    [tempDic setObject:@"1" forKey:@"PSN"];
    [tempDic setObject:_orderMdeol.receiptId forKey:@"RID"];
    [tempDic setObject:_createRPHandle.requestObj.eu forKey:@"EUID"];
    _createRPHandle.requestObj.d = tempDic;
    [_createRPHandle sendRequest];
    _createRPHandle.delegate = self;
    
}

-(void)setOrderMdeol:(OrdersModel *)orderMdeol
{
    _orderMdeol = orderMdeol;
    _orderNumber.text = _orderMdeol.receiptId;
    _content.text = _orderMdeol.content;
    _userTel.text = [NSString stringWithFormat:@"%@ %@",_orderMdeol.userName,_orderMdeol.userPhone];
    
    if ([_orderMdeol.type isEqualToString:@"01"]) {
        _date.text = _orderMdeol.createTime;
    }else{
        _date.text = _orderMdeol.subscribeTime;
    }
    
    if (![_orderMdeol.category1 isEqualToString:@""]||
        ![_orderMdeol.category2 isEqualToString:@""]) {
        _category.text = [NSString stringWithFormat:@"%@-%@",_orderMdeol.category1,_orderMdeol.category2];
    }else{
        _category.text = @"";
    }

    
}

#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _createRPHandle) {
        
        [HUDView hide:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAcceptedPrompt" object:nil];
    }
    
}

- (void)failured:(id)handle error:(NSError *)error
{
    
}



@end

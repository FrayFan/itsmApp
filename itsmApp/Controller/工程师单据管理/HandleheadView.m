//
//  HandleheadView.m
//  itsmApp
//
//  Created by admin on 2016/12/9.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "HandleheadView.h"
#import "BillsDetailController.h"
#import "UIView+ViewController.h"

@interface HandleheadView ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *userInfor;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *category;

- (IBAction)actionButton:(id)sender;


@end

@implementation HandleheadView


- (IBAction)quickHandleAction:(UIButton *)sender {
    
    NSInteger section = sender.tag;
    [self.delegate updateSectionOfTableView:section];

}

-(void)setOrderModel:(OrdersModel *)orderModel
{
    _orderModel = orderModel;
    
    _orderNumber.text= _orderModel.receiptId;
    _content.text = _orderModel.content;
    _userInfor.text = [NSString stringWithFormat:@"%@ %@ %@",_orderModel.userDept,_orderModel.userName,_orderModel.userPhone];
    
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
    
    if (![_orderModel.orginalType isEqualToString:@"手机APP"]) {
        _quickHandle.enabled = NO;
    }
}


- (IBAction)actionButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BillsDetail" bundle:nil];
    BillsDetailController *billsDetailVC = [storyboard instantiateInitialViewController];
    UIViewController *selfC = [self viewController];
    if (billsDetailVC) {
        
        billsDetailVC.orderModel = _orderModel;
        [selfC.navigationController pushViewController:billsDetailVC animated:YES];
    }

    
}
@end

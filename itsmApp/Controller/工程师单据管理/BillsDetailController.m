//
//  BillsDetailController.m
//  itsmApp
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BillsDetailController.h"
#import "DetailTableView.h"
#import "GraycoverPromptView.h"
#import "common.h"
#import "AudioManager.h"
#import "MBProgressHUD.h"

@interface BillsDetailController ()<SubmitPromptViewDelegate,SubmitSolveViewDelegate,NetworkHandleDelegate>
@property (strong,nonatomic) GetOrderDetailHandle *detailHandle;
@property (strong,nonatomic) DetailTableView *billsDetailTView;
@property (strong,nonatomic) GetCreateRPHandle *createRPHandle;
@property (strong,nonatomic) GraycoverPromptView *warningPromptView;
@property (weak, nonatomic) IBOutlet UIView *orderCancel;//订单已取消
@property (weak, nonatomic) IBOutlet UIView *commitView;//底部提交视图
@property (weak, nonatomic) IBOutlet UIButton *commitLeft;
@property (weak, nonatomic) IBOutlet UIButton *commitRight;

- (IBAction)programmeAction:(id)sender;//提交方案
- (IBAction)finishAction:(id)sender;//提交解决
- (IBAction)backAction:(id)sender;//返回

@end

@implementation BillsDetailController
{
    GraycoverPromptView *grayView;
    MBProgressHUD *HUDView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDataFromDetailVC" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _billsDetailTView = [[DetailTableView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    _billsDetailTView.backgroundColor = LightGrayColor;
    [self.view addSubview:_billsDetailTView];
    [self.view insertSubview:_commitView aboveSubview:_billsDetailTView];
    [self.view insertSubview:_orderCancel aboveSubview:_commitView];
    if ([_orderModel.ticketStatus isEqualToString:@"已受理"]||
        ![_orderModel.orginalType isEqualToString:@"手机APP"]) {
        _commitView.hidden = YES;
        _orderCancel.hidden = YES;
    }
    
    [self addHUDVIew];
    [self sendOrderDetailRequest];
}

- (void)addHUDVIew
{
    HUDView = [[MBProgressHUD alloc]init];
    HUDView.labelText = @"正在加载";
    [self.view addSubview:HUDView];
}
- (void)sendOrderDetailRequest
{
    //发送单据详情请求
    _detailHandle = [[GetOrderDetailHandle alloc]init];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_detailHandle.requestObj.d];
    [tempDic setObject:_orderModel.receiptId forKey:@"RID"];
    [tempDic setObject:@"02" forKey:@"RK"];
    [tempDic removeObjectForKey:@"TS"];
    _detailHandle.requestObj.d = tempDic;
    [_detailHandle sendRequest];
    _detailHandle.delegate = self;
    [HUDView show:YES];
    
}
- (IBAction)programmeAction:(id)sender//提交方案
{
    if (![_billsDetailTView.textView.text isEqualToString:@""]) {
        
        [HUDView show:YES];
        //发送提交方案请求
        _createRPHandle = [[GetCreateRPHandle alloc]init];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_createRPHandle.requestObj.d];
        [tempDic setObject:@"2" forKey:@"PSN"];
        [tempDic setObject:_createRPHandle.requestObj.eu forKey:@"EUID"];
        [tempDic setObject:_orderModel.receiptId forKey:@"RID"];
        [tempDic setObject:_billsDetailTView.textView.text forKey:@"PSLT"];
        _createRPHandle.requestObj.d = tempDic;
        [_createRPHandle sendRequest];
        _createRPHandle.delegate = self;
        
    }else{
        //提示输入方案内容
        [self getWarningPromptViewWithText:@"方案内容不能为空" TextWidth:150];
    }
    
}

#pragma mark - SubmitPromptViewDelegate

-(void)removeSubmitPromptView
{
    //移除提示框、返回首页
    [grayView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)finishAction:(id)sender//提交解决
{
    grayView = [[GraycoverPromptView alloc] initWithFrame:self.view.frame getSubmitSolveView:nil];
    grayView.submitSolveView.delegate = self;
    grayView.submitSolveView.orderModel = _orderModel;
    [self.view.window addSubview:grayView];
}

#pragma mark - SubmitSolveViewDelegate

- (void)removeSubmitSolveViewByCancel
{
    [grayView removeFromSuperview];
    
}
- (void)removeSubmitSolveViewByConfirm
{
    [grayView removeFromSuperview];
    
}

- (void)refreshData
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDataFromDetailVC" object:nil];
}

#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _detailHandle) {
        
        [HUDView hide:YES];
        DetailModel *detailModel = _detailHandle.detailModels[0];
        detailModel.identity = _orderModel.identity;
        _billsDetailTView.detailModel = detailModel;
        [_billsDetailTView reloadData];
        
        if ([_orderModel.ticketStatus isEqualToString:@"已取消"]) {
            _orderCancel.hidden = NO;
        }else{
            _orderCancel.hidden = YES;
        }
        
        if (![_orderModel.ticketStatus isEqualToString:@"已受理"]&&![_orderModel.ticketStatus isEqualToString:@"进行中"]) {
            
            [_commitLeft setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_commitRight setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _commitLeft.userInteractionEnabled = NO;
            _commitRight.userInteractionEnabled = NO;
        }
    }
    
    if (handle == _createRPHandle) {
        
        [HUDView hide:YES];
        grayView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getSubmitPromptView:@"方案已提交" buttonTitle:nil];
        grayView.submitPromptView.delegate = self;
        [self.view.window addSubview:grayView];
    }
    
}

- (void)failured:(id)handle error:(NSError *)error
{
    [HUDView hide:YES];
    if (handle == _detailHandle) {
     
        [self getWarningPromptViewWithText:@"加载失败" TextWidth:100];
    }
    
    if (handle == _createRPHandle) {
     
        [self getWarningPromptViewWithText:@"提交失败" TextWidth:100];
    }
    
}

- (void)getWarningPromptViewWithText:(NSString *)text TextWidth:(CGFloat)textWidth
{
    //提示加载失败
    _warningPromptView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getWarningViewWidth:textWidth withWarningText:text];
    [UIView animateWithDuration:1.5 animations:^{
        [self.view.window addSubview:_warningPromptView];
        _warningPromptView.alpha = 1;
        _warningPromptView.alpha = 0.9;
        _warningPromptView.alpha = 0;
    }];
    
}


-(void)setOrderModel:(OrdersModel *)orderModel{
    
    _orderModel = orderModel;
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    AudioManager *manager = [AudioManager sharedManager];
    [manager stopPlaying];
}
@end

//
//  HandleTableViewCell.m
//  itsmApp
//
//  Created by admin on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "HandleTableViewCell.h"
#import "UIView+Additions.h"
#import "GraycoverPromptView.h"
#import "UIView+ViewController.h"
#import "BillsViewController.h"
#import "MBProgressHUD.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HandleTableViewCell ()<SubmitPromptViewDelegate,SubmitSolveViewDelegate,NetworkHandleDelegate,UITextViewDelegate>

@property (strong,nonatomic) GraycoverPromptView *warningPromptView;
@property (nonatomic,strong) GetCreateRPHandle *createRPHandle;
- (IBAction)commitPlan:(id)sender;//提交方案
- (IBAction)commitSolve:(id)sender;//提交解决

@end

@implementation HandleTableViewCell{
    
    GraycoverPromptView *grayView;
    UIView *editView;
    UILabel *waterLable;
    UIView *clearView;
    MBProgressHUD *HUDView;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REMOVECLEARVIEW" object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    editView = [self viewWithTag:345];
    _textView = [self viewWithTag:130];
    _textView.delegate = self;
    waterLable = [self viewWithTag:350];
    
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changEditViewFrame:) name:UIKeyboardWillShowNotification object:nil];
    //收起键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeClearView:) name:@"REMOVECLEARVIEW" object:nil];
    
    HUDView = [[MBProgressHUD alloc]init];
    HUDView.labelText = @"正在提交";

}

- (void)changEditViewFrame:(NSNotification *)notification
{
    //获取键盘frame
    CGRect keyframe = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //透明视图、点击隐藏键盘
    clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    clearView.bottom = ScreenHeight-(100+keyframe.size.height);
    clearView.backgroundColor = [UIColor clearColor];
    clearView.tag = 1001;
    clearView.hidden = NO;
    clearView.backgroundColor = [UIColor clearColor];
    UIViewController *selfC = [self viewController];
    [selfC.view insertSubview:clearView belowSubview:editView];
    waterLable.hidden = YES;
    
}
//收起键盘
- (void)removeClearView:(NSNotification *)notification
{
    [_textView resignFirstResponder];
    if (_textView.text.length != 0) {
        
        waterLable.hidden = YES;
    }else{
        
        waterLable.hidden = NO;
    }

}

//提交方案
- (IBAction)commitPlan:(id)sender {
    
    if (![_textView.text isEqualToString:@""]) {
        
        [self.viewController.view addSubview:HUDView];
        [HUDView show:YES];
        //发送提交方案请求
        [_textView resignFirstResponder];
        _createRPHandle = [[GetCreateRPHandle alloc]init];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_createRPHandle.requestObj.d];
        [tempDic setObject:@"2" forKey:@"PSN"];
        [tempDic setObject:_orderModel.receiptId forKey:@"RID"];
        [tempDic setObject:_createRPHandle.requestObj.eu forKey:@"EUID"];
        [tempDic setObject:_textView.text forKey:@"PSLT"];
        _createRPHandle.requestObj.d = tempDic;
        [_createRPHandle sendRequest];
        _createRPHandle.delegate = self;
    }else{
        
        //提示输入方案内容
        _warningPromptView = [[GraycoverPromptView alloc]initWithFrame:self.viewController.view.frame getWarningViewWidth:150 withWarningText:@"方案内容不能为空"];
        [UIView animateWithDuration:1.5 animations:^{
            [self.viewController.view.window addSubview:_warningPromptView];
            _warningPromptView.alpha = 1;
            _warningPromptView.alpha = 0.9;
            _warningPromptView.alpha = 0;
        }];
        

    }
    
}


//提交解决
- (IBAction)commitSolve:(UIButton*)sender {
    
    [_textView resignFirstResponder];
    UIViewController *selfC = [self viewController];
    grayView = [[GraycoverPromptView alloc]initWithFrame:selfC.view.frame getSubmitSolveView:nil];
    grayView.submitSolveView.delegate = self;
    grayView.submitSolveView.orderModel = _orderModel;
    [selfC.view.window addSubview:grayView];
    
}

#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _createRPHandle) {
        
        [HUDView hide:YES];
        UIViewController *selfC = [self viewController];
        grayView = [[GraycoverPromptView alloc]initWithFrame:selfC.view.frame getSubmitPromptView:@"方案已提交" buttonTitle:nil];
        grayView.submitPromptView.delegate = self;
        [selfC.view.window addSubview:grayView];
        
    }
    
}

- (void)failured:(id)handle error:(NSError *)error
{
    
}

#pragma mark - SubmitPromptViewDelegate

-(void)removeSubmitPromptView
{
    UIViewController *selfC = [self viewController];
    [grayView removeFromSuperview];
    [selfC.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - SubmitSolveViewDelegate

-(void)removeSubmitSolveViewByCancel
{
    [grayView removeFromSuperview];
}

-(void)removeSubmitSolveViewByConfirm
{
    [grayView removeFromSuperview];
}

- (void)refreshData
{
    BillsViewController *selfVC = (BillsViewController*)self.viewController;
    [selfVC.handleTableView upRefreshData];
}

#pragma  mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>= 180) {
        return NO;
    }else{
        return YES;
    }
    
}


@end

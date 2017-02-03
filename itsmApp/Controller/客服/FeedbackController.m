//
//  FeedbackController.m
//  itsmApp
//
//  Created by admin on 2016/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "FeedbackController.h"
#import "FeedbackFirstCell.h"
#import "FeedbackSecondCell.h"
#import "ImagePickerHandler.h"
#import "GraycoverPromptView.h"
#import "MyFeedbackController.h"
#import "common.h"
#import "BillsInputFileManager.h"
#import "FileUploadHandle.h"
#import "UserFeedbackHandle.h"
#import "MBProgressHUD.h"
#import "GetServiceHandle.h"

@interface FeedbackController ()<UITableViewDelegate,UITableViewDataSource,ImagePickerHandlerDelegate,FeedbackTitleViewDelegate,FeedbackFirstCellDelegate,SubmitPromptViewDelegate,NetworkHandleDelegate>

@property (nonatomic,strong) UITableView *feedbackTableView;
@property (nonatomic,strong) ImagePickerHandler *imagePackerHander;
@property (nonatomic,strong) GraycoverPromptView *pickerView;
@property (nonatomic,strong) GraycoverPromptView *sendPromptView;
@property (nonatomic,strong) UIView *clearView;
@property (nonatomic,copy) NSString *firstButtonTitle;
@property (nonatomic,copy) NSString *serviceId;
@property (nonatomic,strong) FileUploadHandle *fileUploadHandle;
@property (nonatomic,strong) UserFeedbackHandle *userFeedbackHandle;

- (IBAction)backAction:(id)sender;//返回
- (IBAction)myViews:(id)sender;//我的反馈

@end

@implementation FeedbackController
{
    GraycoverPromptView *warningPromptView;
}


-(void)dealloc
{

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _imagePackerHander = [[ImagePickerHandler alloc]init];
    _imagePackerHander.maxImages = 3;
    _imagePackerHander.viewController = self;
    
    self.fileUploadHandle = [[FileUploadHandle alloc] init];
    self.fileUploadHandle.type = 2;
    self.fileUploadHandle.delegate = self;
    
    self.userFeedbackHandle = [[UserFeedbackHandle alloc] init];
    self.userFeedbackHandle.delegate = self;
    
    _feedbackTableView = [self.view viewWithTag:666];
    _feedbackTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _feedbackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //选择服务类型提示
    _pickerView = [[GraycoverPromptView alloc] initWithFrame:self.view.frame getChoseOrderStyleView:nil];
    _pickerView.feedbackTitleView.delegate = self;
    
    ServiceCatalog *catalog = [ServiceCatalog localCacheServiceCatalog][0];
    _pickerView.feedbackTitleView.titleLable.text = catalog.name;
    _pickerView.feedbackTitleView.serviceId = catalog.serviceId;
    _pickerView.pickerView.service = [ServiceCatalog localCacheServiceCatalog];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TABLEVIEWCELL"];
    FeedbackFirstCell *firstCell = [[NSBundle mainBundle] loadNibNamed:@"FeedbackFirstCell" owner:nil options:nil].lastObject;
    firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    FeedbackSecondCell *secondCell = [[NSBundle mainBundle] loadNibNamed:@"FeedbackSecondCell" owner:nil options:nil].lastObject;
        
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        
        UILabel *serverLabel = [firstCell viewWithTag:120];
        serverLabel.text = _firstButtonTitle;
        firstCell.delegate = self;
        return firstCell;
    }else if (indexPath.section == 1&indexPath.row == 0){
        secondCell.imagePickerHandler = self.imagePackerHander;
        return secondCell;
    }else{
        
        UIButton *button = [[UIButton alloc] initWithFrame:tableViewCell.bounds];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitleColor:BlueColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewCell addSubview:button];
        return tableViewCell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return 45;
        }
            break;
        case 1:
        {
            return 385;
        }
            break;
            
        default:
        {
            return 45;
        }
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = LightGrayColor;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 8;
        }
            break;
        case 1:
        {
            return 8;
        }
            break;

        default:
        {
            return 18;
        }
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //收起键盘
    FeedbackSecondCell *secondCell = [_feedbackTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITextView *textView = secondCell.feedbackTextView;
    [textView resignFirstResponder];
    
    //隐藏、显示水印
    if (secondCell.feedbackTextView.text.length>0) {
       secondCell.promptLable.hidden = YES;
    }else{
       secondCell.promptLable.hidden = NO;
    }
}

#pragma mark ImagePickerHandlerDelegate

- (void)didFinishImagePickerHandler:(ImagePickerHandler *)handle
{
    FeedbackSecondCell *secondCell = [_feedbackTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UICollectionView *collectionView = secondCell.imageCollectionView;
    
    [collectionView reloadData];
}


#pragma mark - FeedbackTitleViewDelegate

- (void)removeFeedbackPickerView
{
    [_pickerView removeFromSuperview];
}
- (void)removeFeedbackPickerViewChangeTitle:(NSString *)title
{
    self.firstButtonTitle = title;
    self.serviceId = _pickerView.feedbackTitleView.serviceId;
    [_pickerView removeFromSuperview];
    FeedbackFirstCell *firstCell = [_feedbackTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *serverLabel = [firstCell viewWithTag:120];
    serverLabel.text = _firstButtonTitle;
}

#pragma mark - FeedbackFirstCellDelegate
- (void)showFeedbackPickerView
{
    [self.view endEditing:YES];
    [_clearView removeFromSuperview];
    [self.view addSubview:_pickerView];
}

//发送
- (void)sendButtonAction:(UIButton *)button
{
    FeedbackSecondCell *secondCell = [_feedbackTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if ([secondCell.feedbackTextView.text length] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入反馈信息";
        [hud hide:YES afterDelay:0.3];
        return;
    }
    
    self.userFeedbackHandle.feedback = secondCell.feedbackTextView.text;
    self.userFeedbackHandle.scg = self.serviceId;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在提交反馈";
    if (self.imagePackerHander.pictureArray.count > 0) {
        NSString *feedbackzipPath = [BillsInputFileManager archiveBillsWithPics:self.imagePackerHander.pictureArray audiosPath:nil otherFile:nil];
        if (feedbackzipPath.length > 0) {
            self.fileUploadHandle.zipFilePath = feedbackzipPath;
            [self.fileUploadHandle sendRequest];
        }
    }
    else
    {
        [self.userFeedbackHandle buildFeedbackData];
        [self.userFeedbackHandle sendRequest];
    }

}

#pragma mark - SubmitPromptViewDelegate
-(void)removeSubmitPromptView
{
    [_sendPromptView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)myViews:(id)sender {
    
    MyFeedbackController *myFeedbackVC = [[NSBundle mainBundle] loadNibNamed:@"MyFeedbackController" owner:nil options:nil].lastObject;
    [self.navigationController pushViewController:myFeedbackVC animated:YES];
    
}

#pragma mark NetworkHandleDelegate


- (void)successed:(id)handle response:(id)response
{
    if (self.fileUploadHandle == handle) {
        self.userFeedbackHandle.picDict = self.fileUploadHandle.resultDict;
        [self.userFeedbackHandle buildFeedbackData];
        [self.userFeedbackHandle sendRequest];
    }
    else if (self.userFeedbackHandle == handle)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _sendPromptView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getSubmitPromptView:@"意见已发送" buttonTitle:nil];
        _sendPromptView.submitPromptView.delegate = self;
        [self.view.window addSubview:_sendPromptView];
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self getWarningPromptViewWithText:@"提交失败" TextWidth:100];
    if (self.fileUploadHandle == handle) {
        self.fileUploadHandle.zipFilePath = nil;
    }
    else if (self.userFeedbackHandle == handle)
    {
        
    }
}

- (void)getWarningPromptViewWithText:(NSString *)text TextWidth:(CGFloat)textWidth
{
    //提示输入评价内容
    warningPromptView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getWarningViewWidth:textWidth withWarningText:text];
    [UIView animateWithDuration:1.5 animations:^{
        [self.view.window addSubview:warningPromptView];
        warningPromptView.alpha = 1;
        warningPromptView.alpha = 0.9;
        warningPromptView.alpha = 0;
    }];
    
}


@end

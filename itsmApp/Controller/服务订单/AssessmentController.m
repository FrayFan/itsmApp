//
//  AssessmentController.m
//  itsmApp
//
//  Created by admin on 2016/11/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "AssessmentController.h"
#import "UIView+Additions.h"
#import "UIImage+Image.h"
#import "TagCollectionView.h"
#import "GraycoverPromptView.h"
#import "UIView+ViewController.h"
#import "CenterViewController.h"
#import "GetEvaluateHandle.h"
#import "GetSubmitEvaHandle.h"
#import "NSString+Class.h"
#import "common.h"
#import "UIImageView+WebCache.h"
#import "LMJScrollTextView.h"
#import "MBProgressHUD.h"

#define WidthCollection (315.0/375.0)*([[UIScreen mainScreen] bounds].size.width)

@interface AssessmentController ()<UITextViewDelegate,CommitPromptViewDelegate,NetworkHandleDelegate,TagCollectionViewDelegate>
{
    
    UILabel *promptLable;
    UIView *airView;
    UIView *upSplitline;
    UIView *downSplitline;
    NSInteger selectCount;
    LMJScrollTextView *scrollTextView;
    GraycoverPromptView *commitView;
    GraycoverPromptView *warningPromptView;
    
}
@property (strong,nonatomic) GetEvaluateHandle *evaluateHandle;
@property (strong,nonatomic) GetSubmitEvaHandle *submitEvaHandle;
@property (weak, nonatomic) IBOutlet UILabel *engineerTel;//工程师名字
@property (weak, nonatomic) IBOutlet UIImageView *icon;//头像
@property (weak, nonatomic) IBOutlet UILabel *commentLable;//满意度
@property (weak, nonatomic) IBOutlet UILabel *engineerLable;//评价工程师
@property (weak, nonatomic) IBOutlet TagCollectionView *collectionView;//评价标签
@property (weak, nonatomic) IBOutlet UITextView *textView;//文字输入视图
@property (weak, nonatomic) IBOutlet UIView *underView;//上半部底视图
@property (weak, nonatomic) IBOutlet UIButton *starButton1;//星星按钮
@property (weak, nonatomic) IBOutlet UIButton *starButton2;
@property (weak, nonatomic) IBOutlet UIButton *starButton3;
@property (weak, nonatomic) IBOutlet UIButton *starButton4;
@property (weak, nonatomic) IBOutlet UIButton *starButton5;


- (IBAction)commitAction:(id)sender;//提交评价
- (IBAction)switchButton:(id)sender;//换一批
- (IBAction)backButton:(id)sender;


@end

@implementation AssessmentController
{
    MBProgressHUD *HUDView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SUBMITEVARELOAD" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHUDView];
    
    [self sendEvaluateListrequest];
    
    [self createSubviews];
    
    [self setOrderModel:_orderModel];
    
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextViewPosition:) name:UIKeyboardWillShowNotification object:nil];
    
    //弹出、移除提示框
    commitView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getComPromptView:nil];
    commitView.commitPromptView.delagate = self;

}

- (void)addHUDView
{
    HUDView = [[MBProgressHUD alloc]init];
    HUDView.labelText = @"正在加载";
    [self.view addSubview:HUDView];
}

- (void)sendEvaluateListrequest
{
    [HUDView show:YES];
    
    //发送评价目录请求
    _evaluateHandle = [[GetEvaluateHandle alloc]init];
    [_evaluateHandle sendRequest];
    _evaluateHandle.delegate = self;
}

- (void)createSubviews{
    
    _collectionView.warningDelegate = self;
    
    //设置textView默认提示文字
    _textView.delegate = self;
    promptLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 20)];
    promptLable.enabled = NO;
    promptLable.text = @"请输入文字意见";
    promptLable.font = [UIFont systemFontOfSize:15];
    promptLable.textColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:.5];
    [_textView addSubview:promptLable];
    
    //星星点击
    NSArray *starButtons =
    @[_starButton1,_starButton2,_starButton3,_starButton4,_starButton5];
    
    for (int a = 1; a < starButtons.count+1; a++) {
        
        UIButton *starbutton = starButtons[a-1];
        starbutton.tag = a;
        [starbutton setImage:[UIImage imageNamed:@"icon_hightLight"] forState:UIControlStateSelected];
        [starbutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    
    
    //透明遮挡视图
    airView = [[UIView alloc]initWithFrame:CGRectMake(0, 72, KScreenWidth,_textView.top)];
    airView.backgroundColor = [UIColor clearColor];
    airView.hidden = YES;
    [_underView insertSubview:airView belowSubview:_textView];
    
    //分割线
    upSplitline = [[UIView alloc]init];
    upSplitline.backgroundColor = LightGrayWhite;
    CGFloat y = _engineerLable.top + _engineerLable.frame.size.height/2;
    upSplitline.frame = CGRectMake(15, y, KScreenWidth-30, .5);
    [_underView insertSubview:upSplitline belowSubview:_engineerLable];
    
    downSplitline = [[UIView alloc]initWithFrame:CGRectMake(0, _textView.top-1, KScreenWidth, .5)];
    downSplitline.backgroundColor = LightGrayWhite;
    [_underView addSubview:downSplitline];
    
    //滚动技能视图
    scrollTextView = [[LMJScrollTextView alloc]initWithFrame:CGRectMake(90, 50, KScreenWidth-105, 19) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    [_underView addSubview:scrollTextView];
}

-(void)viewDidLayoutSubviews
{
    //重新设置标签视图宽度
    if (KScreenWidth > 320) {
        
        CGRect collectviewFrame = _collectionView.frame;
        collectviewFrame.size.width = WidthCollection - 50;
        if (KScreenWidth > 375) {
            collectviewFrame.size.width = WidthCollection - 70;
        }
        collectviewFrame.origin.x = (KScreenWidth - collectviewFrame.size.width)/2;
        _collectionView.frame = collectviewFrame;
    }
    
}

// 键盘弹起、键盘收起
- (void)changeTextViewPosition:(NSNotification *)notification
{
    CGRect keyframe = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _underView.transform = CGAffineTransformMakeTranslation(0,KScreenHeight - _underView.bottom - keyframe.size.height);
    airView.hidden = NO;
    promptLable.hidden = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:.5 animations:^{
        [_textView resignFirstResponder];
        _underView.transform = CGAffineTransformIdentity;
    }];
    if (_textView.text.length != 0) {
        
        promptLable.hidden = YES;
    }else{
        promptLable.hidden = NO;
    }
    
    airView.hidden = YES;
}


//提交评价
- (IBAction)commitAction:(id)sender {
    
    if ((_collectionView.selectItemDics.count >0)||
        (![_textView.text isEqualToString:@""])) {
        
        [HUDView show:YES];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_submitEvaHandle.requestObj.d];
        NSString *RKString = [NSString integerMakeString:_collectionView.starCount];
        [tempDic setObject:_orderModel.receiptId forKey:@"RID"];
        [tempDic setObject:_orderModel.userId forKey:@"UID"];
        [tempDic setObject:RKString forKey:@"RK"];
        
        if (_collectionView.selectItemDics.count >0) {
            [tempDic setObject:_collectionView.selectItemDics forKey:@"CTS"];
        }
        if (![_textView.text isEqualToString:@""]) {
            [tempDic setObject:_textView.text forKey:@"EVCT"];
        }else{
            [tempDic setObject:@"" forKey:@"EVCT"];
        }
        
        //发送提交评价请求
        _submitEvaHandle = [[GetSubmitEvaHandle alloc]init];
        _submitEvaHandle.requestObj.d = tempDic;
        [_submitEvaHandle sendRequest];
        _submitEvaHandle.delegate = self;
        
    }else{

        [self getWarningPromptViewWithText:@"请选择评价标签或输入文字评价" TextWidth:250];
    }

    
}

#pragma mark - CommitPromptViewDelegate

-(void)removeCommitPromptViewOnGraycoverView:(NSInteger)buttonTag
{
    [commitView removeFromSuperview];
    if (buttonTag == 111) {
        //返回首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        //查看服务单
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SUBMITEVARELOAD" object:nil];
    }
    
}

//换一批
- (IBAction)switchButton:(id)sender
{
    [_collectionView switchCollectionViewPage];
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//星星评分按钮
- (void)buttonAction:(UIButton *)button
{
    button.selected = !button.selected;

    switch (button.tag) {
            
        case 1:
        {
            EvaluateModel *evalModel = _evaluateHandle.evaluteModels[0];
            _collectionView.items = evalModel.catalogs;
            _collectionView.starCount = button.tag;
            _commentLable.text = evalModel.abstract;
            [_collectionView reloadData];
            _starButton1.selected = YES;
            _starButton2.selected = NO;
            _starButton3.selected = NO;
            _starButton4.selected = NO;
            _starButton5.selected = NO;
        }
            
            break;
        case 2:
        {
            EvaluateModel *evalModel = _evaluateHandle.evaluteModels[1];
            _collectionView.items = evalModel.catalogs;
            _collectionView.starCount = button.tag;
            _commentLable.text = evalModel.abstract;
            [_collectionView reloadData];
            _starButton1.selected = YES;
            _starButton2.selected = YES;
            _starButton3.selected = NO;
            _starButton4.selected = NO;
            _starButton5.selected = NO;
        }
            break;
        case 3:
        {
            EvaluateModel *evalModel = _evaluateHandle.evaluteModels[2];
            _collectionView.items = evalModel.catalogs;
            _collectionView.starCount = button.tag;
            _commentLable.text = evalModel.abstract;
            [_collectionView reloadData];
            _starButton1.selected = YES;
            _starButton2.selected = YES;
            _starButton3.selected = YES;
            _starButton4.selected = NO;
            _starButton5.selected = NO;
        }
            break;
        case 4:
        {
            EvaluateModel *evalModel = _evaluateHandle.evaluteModels[3];
            _collectionView.items = evalModel.catalogs;
            _collectionView.starCount = button.tag;
            _commentLable.text = evalModel.abstract;
            [_collectionView reloadData];
            _starButton1.selected = YES;
            _starButton2.selected = YES;
            _starButton3.selected = YES;
            _starButton4.selected = YES;
            _starButton5.selected = NO;
        }
            break;
            
        case 5:
        {
            EvaluateModel *evalModel = _evaluateHandle.evaluteModels[4];
            _collectionView.items = evalModel.catalogs;
            _collectionView.starCount = button.tag;
            _commentLable.text = evalModel.abstract;
            [_collectionView reloadData];
            _starButton1.selected = YES;
            _starButton2.selected = YES;
            _starButton3.selected = YES;
            _starButton4.selected = YES;
            _starButton5.selected = YES;
        }
            break;

    }
    
}

#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _evaluateHandle) {
        
        [HUDView hide:YES];
        [self buttonAction:_starButton4];
        [_collectionView reloadData];

    }
    
    if (handle == _submitEvaHandle) {
        
        [HUDView hide:YES];
        [UIView animateWithDuration:.2 animations:^{
            commitView.alpha = .5;
            commitView.alpha = 1;
            [self.view.window addSubview:commitView];
        }];
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    if (handle == _evaluateHandle) {
        
        [HUDView hide:YES];
        [self getWarningPromptViewWithText:@"加载失败" TextWidth:100];
    }
    
    if (handle == _submitEvaHandle) {
        
        [HUDView hide:YES];
        [self getWarningPromptViewWithText:@"提交失败" TextWidth:100];
    }

}

-(void)setOrderModel:(OrdersModel *)orderModel
{
    _orderModel = orderModel;
    
    _icon.layer.cornerRadius = _icon.height/2;
    _icon.layer.masksToBounds = YES;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_orderModel.engineerModel.engineerHeadImg] placeholderImage:[UIImage imageNamed:@"default_face"]];
    _engineerTel.text = [NSString stringWithFormat:@"%@ %@",_orderModel.engineerModel.engineerName,_orderModel.engineerModel.engineerPhone];
    [scrollTextView startScrollWithText:_orderModel.engineerModel.skill textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:19]];
    
}

//提示标签
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

#pragma  mark - TagCollectionViewDelegate
- (void)addWarningPromptView
{
    [self getWarningPromptViewWithText:@"最多可选3个评价标签" TextWidth:200];
}


@end

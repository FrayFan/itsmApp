//
//  GraycoverPromptView.h
//  itsmApp
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectActionView.h"
#import "CommitPromptView.h"
#import "SubmitPromptView.h"
#import "SubmitSolveView.h"
#import "FeedbackPickerView.h"
#import "FeedbackTitleView.h"

@interface GraycoverPromptView : UIView

@property (nonatomic,strong) SelectActionView *selectActionView;
@property (nonatomic,strong) CommitPromptView *commitPromptView;
@property (nonatomic,strong) SubmitPromptView *submitPromptView;
@property (nonatomic,strong) SubmitSolveView *submitSolveView;
@property (nonatomic,strong) FeedbackPickerView *pickerView;
@property (nonatomic,strong) FeedbackTitleView *feedbackTitleView;

- (instancetype)initWithFrame:(CGRect)frame getSelectActionView:(UIView *)selectActionView;//选择订单状态提示

- (instancetype)initWithFrame:(CGRect)frame getComPromptView:(UIView *)comPromprview;//提交评价提示

-(instancetype)initWithFrame:(CGRect)frame getSubmitPromptView:(NSString *)
titleText buttonTitle:(NSString *)buttonTitle;//提交方案提示、提交申请提示、发送提交反馈意见

-(instancetype)initWithFrame:(CGRect)frame getSubmitSolveView:(UIView *)submitSolveView;//提交解决提示

- (instancetype)initWithFrame:(CGRect)frame getChoseOrderStyleView:(UIView *)choseOrderStyleView;//选择服务类型提示

- (instancetype)initWithFrame:(CGRect)frame getWarningViewWidth:(CGFloat)warningWidth withWarningText:(NSString *)title;//警告文字栏提示

- (instancetype)initWithFrame:(CGRect)frame withPromptText:(NSString *)title;//暂无订单提示

@end

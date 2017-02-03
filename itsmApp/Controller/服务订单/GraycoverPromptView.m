//
//  GraycoverPromptView.m
//  itsmApp
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GraycoverPromptView.h"
#import "common.h"
#import "UIView+ViewController.h"

@interface GraycoverPromptView ()

@end

@implementation GraycoverPromptView

-(instancetype)initWithFrame:(CGRect)frame getSelectActionView:(UIView *)selectActionView
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = GrayColor;
        _selectActionView = [[NSBundle mainBundle] loadNibNamed:@"SelectActionView" owner:nil options:nil].lastObject;
        CGFloat selectViewHight = 342;
        CGFloat selectViewWidth = 94;
        _selectActionView.frame = CGRectMake(KScreenWidth -selectViewWidth-10, 55, selectViewWidth, selectViewHight);
        
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame getComPromptView:(UIView *)comPromprview
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = GrayColor;
        //调整宽度
        CGFloat gapW = 30;
        if (KScreenWidth < 375) {
            gapW = 10;
        }
        
        _commitPromptView = [[NSBundle mainBundle] loadNibNamed:@"CommitPromptView" owner:nil options:nil].lastObject;
        _commitPromptView.frame = CGRectMake(gapW, 0, KScreenWidth-gapW*2, 195);
        _commitPromptView.center = self.center;
        [self addSubview:_commitPromptView];

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame getSubmitPromptView:(NSString *)titleText buttonTitle:(NSString *)buttonTitle
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = GrayColor;
        //调整宽度
        CGFloat gapW = 30;
        if (KScreenWidth < 375) {
            gapW = 10;
        }
        
        _submitPromptView = [[NSBundle mainBundle] loadNibNamed:@"SubmitPromptView" owner:nil options:nil].lastObject;
        _submitPromptView.frame = CGRectMake(gapW, 0, KScreenWidth-gapW*2, 195);
        _submitPromptView.center = self.center;
        UILabel *titleLable = [_submitPromptView viewWithTag:560];
        titleLable.text = titleText;
        UIButton *button = [_submitPromptView viewWithTag:550];
        if (buttonTitle == nil) {
            buttonTitle = @"回到首页";
        }
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [self addSubview:_submitPromptView];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame getSubmitSolveView:(UIView *)submitSolveView
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = GrayColor;
        //调整宽度
        CGFloat gapW = 30;
        if (KScreenWidth < 375) {
            gapW = 10;
        }else if (KScreenWidth > 375){
            gapW = 60;
        }
        
        _submitSolveView = [[NSBundle mainBundle] loadNibNamed:@"SubmitSolveView" owner:nil options:nil].lastObject;
        _submitSolveView.frame = CGRectMake(gapW, 0, KScreenWidth-gapW*2, 153);
        _submitSolveView.center = self.center;
        _submitSolveView.layer.cornerRadius = 15;
        _submitSolveView.layer.masksToBounds = YES;
        [self addSubview:_submitSolveView];
        
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame getChoseOrderStyleView:(UIView *)choseOrderStyleView
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = GrayColor;
                
        _pickerView = [[FeedbackPickerView alloc]initWithFrame:CGRectMake(0, KScreenHeight-160, KScreenWidth, 160)];
        [self addSubview:_pickerView];
        
        _feedbackTitleView = [[NSBundle mainBundle] loadNibNamed:@"FeedbackTitleView" owner:nil options:nil].lastObject;
        _feedbackTitleView.frame = CGRectMake(0, KScreenHeight-200, KScreenWidth, 40);
        [self addSubview:_feedbackTitleView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame getWarningViewWidth:(CGFloat)warningWidth withWarningText:(NSString *)title;

{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UILabel *warningLable = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth-warningWidth)/2, KScreenHeight-100, warningWidth, 30)];
        warningLable.backgroundColor = [UIColor blackColor];
        warningLable.textColor = [UIColor whiteColor];
        warningLable.text = title;
        warningLable.textAlignment = NSTextAlignmentCenter;
        warningLable.font = [UIFont systemFontOfSize:15];
        warningLable.layer.cornerRadius = 8;
        warningLable.layer.masksToBounds = YES;
        
        [self addSubview:warningLable];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withPromptText:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UILabel *propmtLable = [[UILabel alloc]initWithFrame:self.bounds];
        propmtLable.backgroundColor = [UIColor clearColor];
        propmtLable.textColor = DetailColor;
        propmtLable.text = title;
        propmtLable.textAlignment = NSTextAlignmentCenter;
        propmtLable.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:propmtLable];
    }
    return self;
 
}


@end

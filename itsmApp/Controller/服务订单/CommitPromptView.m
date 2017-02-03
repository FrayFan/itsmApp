//
//  CommitPromptView.m
//  itsmApp
//
//  Created by admin on 2016/12/2.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "CommitPromptView.h"
#import "OrderViewController.h"
#import "common.h"

@interface CommitPromptView ()

@property (weak, nonatomic) IBOutlet UIButton *backtoHome;//返回首页
@property (weak, nonatomic) IBOutlet UIButton *checkOrders;//查看服务单

- (IBAction)backToHome:(id)sender;
- (IBAction)checkOrders:(id)sender;

@end

@implementation CommitPromptView
    

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        _backtoHome = [self viewWithTag:111];
        [_backtoHome setBackgroundImage:[UIImage imageNamed:@"voiceBg"] forState:UIControlStateHighlighted];
        [_backtoHome setTitleColor:TitileColor forState:UIControlStateHighlighted];
        _checkOrders = [self viewWithTag:222];
        [_checkOrders setBackgroundImage:[UIImage imageNamed:@"voiceBg"] forState:UIControlStateHighlighted];
        
    }
    return self;
}


- (IBAction)backToHome:(UIButton *)sender {
    
    [self.delagate removeCommitPromptViewOnGraycoverView:sender.tag];
    
}

- (IBAction)checkOrders:(UIButton *)sender {
    
    [self.delagate removeCommitPromptViewOnGraycoverView:sender.tag];
    
}



@end

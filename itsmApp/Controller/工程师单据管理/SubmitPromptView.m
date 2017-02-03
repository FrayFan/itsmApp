//
//  SubmitPromptView.m
//  itsmApp
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "SubmitPromptView.h"


@implementation SubmitPromptView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        _backToHome = [self viewWithTag:550];
        [_backToHome setBackgroundImage:[UIImage imageNamed:@"voiceBg"] forState:UIControlStateHighlighted];
    }
    return self;
}



- (IBAction)backToHome:(id)sender
{
    [self.delegate removeSubmitPromptView];
}
@end

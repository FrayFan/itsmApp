//
//  FeedbackTitleView.m
//  itsmApp
//
//  Created by admin on 2016/12/15.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "FeedbackTitleView.h"
#import "GetServiceHandle.h"

@interface FeedbackTitleView ()

- (IBAction)cancelAction:(id)sender;//取消
- (IBAction)confirmAction:(id)sende;//确定


@end

@implementation FeedbackTitleView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        


    }
    return self;
}


- (IBAction)cancelAction:(id)sender {
    
    [self.delegate removeFeedbackPickerView];
}

- (IBAction)confirmAction:(id)sender {
    
    [self.delegate removeFeedbackPickerViewChangeTitle:self.titleLable.text];
}



@end

//
//  CommitPromptView.h
//  itsmApp
//
//  Created by admin on 2016/12/2.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommitPromptViewDelegate <NSObject>

- (void)removeCommitPromptViewOnGraycoverView:(NSInteger)buttonTag;

@end

@interface CommitPromptView : UIView

@property (nonatomic,weak) id<CommitPromptViewDelegate>delagate;


@end

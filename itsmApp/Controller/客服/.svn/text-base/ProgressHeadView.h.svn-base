//
//  ProgressHeadView.h
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetComplainHandle.h"

@protocol ProgressHeadViewDelegate <NSObject>

- (void)openProgressViewForSection:(NSInteger)section;

@end

@interface ProgressHeadView : UIView

@property (nonatomic,strong) ComplainModel *complainModel;
@property (nonatomic,weak) id<ProgressHeadViewDelegate>delegate;
@property (nonatomic,strong) UIButton *button;

@end

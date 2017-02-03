//
//  FeedbackTitleView.h
//  itsmApp
//
//  Created by admin on 2016/12/15.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedbackTitleViewDelegate <NSObject>

@optional
- (void)removeFeedbackPickerView;
- (void)removeFeedbackPickerViewChangeTitle:(NSString *)title;


@end

@interface FeedbackTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLable;//服务类型标题
@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic,weak) id<FeedbackTitleViewDelegate>delegate;

@end

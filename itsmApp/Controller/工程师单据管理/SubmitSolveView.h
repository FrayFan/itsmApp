//
//  SubmitSolveView.h
//  itsmApp
//
//  Created by admin on 2016/12/9.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"

@protocol  SubmitSolveViewDelegate<NSObject>

- (void)removeSubmitSolveViewByCancel;
- (void)removeSubmitSolveViewByConfirm;

@optional
- (void)refreshData;

@end

@interface SubmitSolveView : UIView

@property (nonatomic,strong) OrdersModel *orderModel;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,weak) id<SubmitSolveViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


- (IBAction)cancelButton:(id)sender;//取消
- (IBAction)confirmButton:(id)sender;//确认



@end

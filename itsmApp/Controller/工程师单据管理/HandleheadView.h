//
//  HandleheadView.h
//  itsmApp
//
//  Created by admin on 2016/12/9.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"

@protocol  HandleheadViewDelegate<NSObject>

@optional
- (void)updateSectionOfTableView:(NSInteger)section;

@end

@interface HandleheadView : UIView

@property (nonatomic,strong) OrdersModel *orderModel;
@property (nonatomic,weak) id<HandleheadViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *quickHandle;

- (IBAction)quickHandleAction:(id)sender;//快速处理


@end

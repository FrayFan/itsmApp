//
//  SelectActionView.h
//  itsmApp
//
//  Created by admin on 2016/12/5.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"

@protocol SelectActionViewDelegate <NSObject>

- (void)removeGrayCoverView;
- (void)changeRightButtonTitle:(NSString *)title withIndex:(NSInteger)index;

@end


@interface SelectActionView : UIView

@property (nonatomic,weak) id<SelectActionViewDelegate>delagate;
@property (nonatomic,strong) OrdersModel *orderModel;

@end

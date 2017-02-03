//
//  MyOrderViewController.h
//  itsmApp
//
//  Created by admin on 2016/11/28.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"
#import "GetProcessHandle.h"
#import "GetOrderDetailHandle.h"
#import "GetCancelHandle.h"

@interface MyOrderViewController : UIViewController

@property (nonatomic,strong) OrdersModel *orderModel;
@property (nonatomic,strong) GetProcessHandle *processHandle;
@property (nonatomic,strong) GetOrderDetailHandle *detailHandle;
@property (nonatomic,strong) GetCancelHandle *cancelHandle;
@end

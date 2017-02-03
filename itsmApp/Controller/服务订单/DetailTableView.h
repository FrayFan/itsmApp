//
//  DetailTableView.h
//  itsmApp
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"
#import "GetOrderDetailHandle.h"

@interface DetailTableView : UITableView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic,strong) OrdersModel *orderModel;
@property (nonatomic,strong) DetailModel *detailModel;
@property (nonatomic,strong) DetailModel *engineerModel;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) BOOL hidden;

@end

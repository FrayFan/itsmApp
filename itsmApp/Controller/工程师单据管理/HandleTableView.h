//
//  HandleTableView.h
//  itsmApp
//
//  Created by admin on 2016/12/6.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandleTableViewCell.h"
#import "HandleheadView.h"
#import "GetOrdersHandle.h"
#import "MJRefresh.h"

@protocol HandleTableViewDelegate <NSObject>

- (void)handleTableViewIsUpRefreshData:(BOOL)refreshBool;
@end

@interface HandleTableView : UITableView<UITableViewDataSource,
UITableViewDelegate,HandleheadViewDelegate>

@property (nonatomic,strong) MJRefreshNormalHeader *normalHeader;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *normalFooter;
@property (nonatomic,weak) id<HandleTableViewDelegate>refreshDelegate;
@property (nonatomic,strong) NSMutableArray *orderModels;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isClickHandle;

- (void)upRefreshData;
- (void)loadMoreData;

@end

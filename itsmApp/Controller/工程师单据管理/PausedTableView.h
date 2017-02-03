//
//  PausedTableView.h
//  itsmApp
//
//  Created by admin on 2016/12/6.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"
#import "MJRefresh.h"

@protocol  PausedTableViewDelgate<NSObject>

- (void)pausedTableViewIsUpRefreshData:(BOOL)refreshBool;
@end

@interface PausedTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *orderModels;
@property (nonatomic,weak) id<PausedTableViewDelgate>refreshDelegate;
@property (nonatomic,strong) MJRefreshNormalHeader *normalHeader;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *normalFooter;
@property (nonatomic,assign) BOOL upRefresh;

- (void)upRefreshData;
- (void)loadMoreData;
@end

//
//  AcceptTableView.h
//  itsmApp
//
//  Created by admin on 2016/12/6.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "AcceptTableViewCell.h"

@protocol  AcceptTableViewDelgate<NSObject>

- (void)acceptTableViewIsUpRefreshData:(BOOL)refreshBool;
@end

@interface AcceptTableView : UITableView<UITableViewDelegate,UITableViewDataSource,AcceptTableViewCellDelegate>

@property (nonatomic,strong) AcceptTableViewCell *cell;
@property (nonatomic,strong) MJRefreshNormalHeader *normalHeader;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *normalFooter;
@property (nonatomic,weak) id<AcceptTableViewDelgate>refreshDelegate;
@property (nonatomic,assign) BOOL upRefresh;
@property (nonatomic,strong) NSMutableArray *orderModels;
@property (nonatomic,strong) NSMutableArray *dataArray;

- (void)upRefreshData;
- (void)loadMoreData;

@end

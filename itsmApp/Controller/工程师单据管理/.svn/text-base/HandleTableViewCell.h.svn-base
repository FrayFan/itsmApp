//
//  HandleTableViewCell.h
//  itsmApp
//
//  Created by admin on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCreateRPHandle.h"
#import "GetOrdersHandle.h"

@protocol HandleViewCellDelegate <NSObject>

- (void)refreshHandleTableViewData;

@end

@interface HandleTableViewCell : UITableViewCell

@property (weak,nonatomic) id<HandleViewCellDelegate>refreshDelegate;
@property (nonatomic,strong) OrdersModel *orderModel;
@property (weak, nonatomic) IBOutlet UIButton *solveButton;
@property (weak, nonatomic) IBOutlet UIButton *idealButton;
@property (strong,nonatomic) UITextView *textView;

@end

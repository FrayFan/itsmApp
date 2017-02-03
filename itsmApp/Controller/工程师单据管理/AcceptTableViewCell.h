//
//  AcceptTableViewCell.h
//  itsmApp
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"

@protocol AcceptTableViewCellDelegate <NSObject>

@optional
- (void)removeIndexPathCellWithIndex:(NSInteger)index;

@end
@interface AcceptTableViewCell : UITableViewCell

@property (strong,nonatomic) OrdersModel *orderMdeol;
@property (weak, nonatomic) IBOutlet UIButton *contactedButton;//已联系按钮
@property (weak,nonatomic) id<AcceptTableViewCellDelegate>dalegate;

@end

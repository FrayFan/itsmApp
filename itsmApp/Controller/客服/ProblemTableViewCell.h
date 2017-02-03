//
//  ProblemTableViewCell.h
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrdersHandle.h"
#import "LMJScrollTextView.h"

@interface ProblemTableViewCell : UITableViewCell

@property (strong,nonatomic) OrdersModel *orderModel;
@property (strong,nonatomic) LMJScrollTextView *scrollTextView;

@end

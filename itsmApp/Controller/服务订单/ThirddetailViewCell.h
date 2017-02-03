//
//  ThirddetailViewCell.h
//  itsmApp
//
//  Created by admin on 2016/12/1.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderDetailHandle.h"
#import "LMJScrollTextView.h"

@interface ThirddetailViewCell : UITableViewCell

@property (strong,nonatomic) DetailModel *thirddetailModel;
- (IBAction)telephone:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UIButton *phoneIcon;
@property (strong,nonatomic) LMJScrollTextView *scrollTextView;

+ (CGFloat)thirdCellHeight;

@end

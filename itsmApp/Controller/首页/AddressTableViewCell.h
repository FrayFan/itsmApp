//
//  AddressTableViewCell.h
//  itsmApp
//
//  Created by itp on 2016/12/30.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJScrollTextView.h"
#import "UIView+Additions.h"
#import "common.h"

@protocol AddressTableViewCellDelegate <NSObject>

@optional

- (void)selectedAddress;

@end

@interface AddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (copy,nonatomic) NSString *addtress;

@property (strong,nonatomic) LMJScrollTextView *scrollAddtress;

@property (weak, nonatomic) id<AddressTableViewCellDelegate> delegate;


@end

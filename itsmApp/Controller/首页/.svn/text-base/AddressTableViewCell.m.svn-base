//
//  AddressTableViewCell.m
//  itsmApp
//
//  Created by itp on 2016/12/30.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _addressLabel.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectAddressAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedAddress)]) {
        [self.delegate selectedAddress];
    }
    
}

-(void)setAddtress:(NSString *)addtress
{
    _addtress = addtress;
    
    [_scrollAddtress removeFromSuperview];
    _scrollAddtress = [[LMJScrollTextView alloc]initWithFrame:CGRectMake(95, 11, KScreenWidth-135, 21) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    _scrollAddtress.isOrderAdd = YES;
    [self addSubview:_scrollAddtress];

    _addtress = [_addtress stringByAppendingString:@"   "];
    [_scrollAddtress startScrollWithText:_addtress textColor:BlueColor font:[UIFont systemFontOfSize:17]];
}

@end

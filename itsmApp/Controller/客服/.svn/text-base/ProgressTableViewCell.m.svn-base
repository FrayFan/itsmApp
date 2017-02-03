//
//  ProgressTableViewCell.m
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ProgressTableViewCell.h"

@interface ProgressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *complainContent;
@property (weak, nonatomic) IBOutlet UILabel *beComplainContent;
@property (strong,nonatomic) GetComProcessHandle *comProcessHandle;
@end


@implementation ProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

-(void)setComProcessModel:(ComProcessModel *)comProcessModel
{
    _comProcessModel = comProcessModel;
    
    _complainContent.text = _comProcessModel.complainContent;
    _beComplainContent.text = _comProcessModel.complainProcessContent;
    if ([_comProcessModel.complainProcessContent isEqualToString:@""]) {
        _beComplainContent.text = @"";
    }
    
    
    
    
}




@end

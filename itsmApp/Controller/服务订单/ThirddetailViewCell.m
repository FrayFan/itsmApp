//
//  ThirddetailViewCell.m
//  itsmApp
//
//  Created by admin on 2016/12/1.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ThirddetailViewCell.h"
#import "UIView+Additions.h"
#import "common.h"

@interface ThirddetailViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *infoLable;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;


@end

@implementation ThirddetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)telephone:(id)sender {
    
    if ([_thirddetailModel.identity isEqualToString:@"01"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_thirddetailModel.engineerModel.engineerPhone]]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_thirddetailModel.userPhone]]];
    }
    
}

+(CGFloat)thirdCellHeight
{
    return 43;
}

-(void)setThirddetailModel:(DetailModel *)thirddetailModel
{
    _thirddetailModel = thirddetailModel;

    _scrollTextView = [[LMJScrollTextView alloc] initWithFrame:CGRectMake(_locationImage.right+10, 14, KScreenWidth-90, 15) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    [self addSubview:_scrollTextView];
    
    
    if ([_thirddetailModel.identity isEqualToString:@"01"]) {

        if (_thirddetailModel.engineerModel.engineerName == nil) {
            
            [ _scrollTextView startScrollWithText:_thirddetailModel.location textColor:DetailColor font:[UIFont systemFontOfSize:13]];
        }else{
            NSString *text = [NSString stringWithFormat:@"%@ %@ %@ %@   ",_thirddetailModel.location,_thirddetailModel.engineerModel.engineerDept,_thirddetailModel.engineerModel.engineerName,_thirddetailModel.engineerModel.engineerPhone];
            [ _scrollTextView startScrollWithText:text textColor:DetailColor font:[UIFont systemFontOfSize:13]];
        }
        
    }else{
        [ _scrollTextView startScrollWithText:[NSString stringWithFormat:@"%@ %@ %@ %@   ",_thirddetailModel.location,_thirddetailModel.userDept,_thirddetailModel.userName,_thirddetailModel.userPhone] textColor:DetailColor font:[UIFont systemFontOfSize:13]];
        
    }
    
    if (_thirddetailModel == nil) {
        _scrollTextView.contentLabel1.text = @"";
        _scrollTextView.contentLabel2.text = @"";
    }
    
}


@end

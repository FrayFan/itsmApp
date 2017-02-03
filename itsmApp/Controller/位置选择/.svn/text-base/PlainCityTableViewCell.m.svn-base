//
//  PlainCityTableViewCell.m
//  itsmApp
//
//  Created by ZTE on 16/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "PlainCityTableViewCell.h"
#import "UIColor+HEX.h"

@implementation PlainCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"plainCell";
    PlainCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PlainCityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.加载View
        [self loadTableCell];
    }
    return self;
}

-(void)loadTableCell
{
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 10,KScreenWidth-30,20)];
    lab.font=[UIFont systemFontOfSize:15.0];
    lab.textColor=[UIColor getColor:@"181818"];
    _citylab=lab;
    [self.contentView addSubview:lab];
}
-(void)setCityName:(NSString *)cityName
{
    _cityName=cityName;
    _citylab.text=self.cityName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  HotCityTableViewCell.m
//  itsmApp
//
//  Created by ZTE on 16/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "HotCityTableViewCell.h"
#import "CityInfo.h"
#import "UIColor+HEX.h"
#define MyColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface HotCityTableViewCell ()
{
    UIButton *selectedButton;
}
@end

@implementation HotCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"hotCell";
    HotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HotCityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    UIView *cellView=[[UIView alloc]init];
    [cellView setBackgroundColor:MyColor(245, 245, 245)];
    cellView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 45);
    _cityView=cellView;
    _cityView.userInteractionEnabled=YES;
    

    [self.contentView addSubview:cellView];
}
-(void)setCityArray:(NSArray *)cityArray
{
    NSInteger rowCount = (cityArray.count+2)/3;
    _cityView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 40*rowCount + 10*(rowCount-1));
    _cityArray=cityArray;
    
    CGFloat left = 15.0;
    CGFloat right = 26.0;
    CGFloat interval = 10.0;
    CGFloat w = (SCREEN_WIDTH - (left+right+interval*2))/3;
    CGFloat h = 40.0;
    CGFloat x = left;
    CGFloat y = 0;
    
    NSInteger row = 0,cloumn = 0;
    for (NSInteger i = 0; i< cityArray.count; i++) {
        HotCityInfo *hotCityInfo = cityArray[i];
        row = i%3;
        cloumn = i/3;
        x= left + row*w + row*interval;
        y= cloumn*h + cloumn*interval;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x,y,w,h);
        [btn setTitle:hotCityInfo.cityName forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        btn.layer.shadowColor = [UIColor clearColor].CGColor;
        [btn.layer setBorderWidth:0.5]; //边框宽度
        [btn setTitleColor:[UIColor getColor:@"181818"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
        [btn addTarget:self action:@selector(btnSelectClike:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [btn.layer setBorderColor:[UIColor getColor:@"d5d5d5"].CGColor];

        [_cityView addSubview:btn];
    }
}
-(void)btnSelectClike:(UIButton *)btn
{
    if (selectedButton == btn) {
        [HotCityTableViewCell button:btn selected:NO];
        selectedButton = nil;
    }
    else
    {
        [HotCityTableViewCell button:selectedButton selected:NO];
        [HotCityTableViewCell button:btn selected:YES];
        selectedButton = btn;
    }
    if([self.hotDelegate respondsToSelector:@selector(hotCityButtonClick:)]){
        [self.hotDelegate hotCityButtonClick:selectedButton];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (void)button:(UIButton *)button selected:(BOOL)selected
{
    if (selected) {
        button.selected = YES;
        button.backgroundColor = [UIColor getColor:@"3ebdf0"];
    }
    else
    {
        button.selected = NO;
        button.backgroundColor = [UIColor whiteColor];
    }
}

@end

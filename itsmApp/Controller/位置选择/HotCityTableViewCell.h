//
//  HotCityTableViewCell.h
//  itsmApp
//
//  Created by ZTE on 16/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol hotCityButtonClickDelegate<NSObject>
@optional
-(void)hotCityButtonClick:(UIButton *)btn;//1.1定义协议与方法
@end


@interface HotCityTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *cityView;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) NSArray  *cityArray;
@property (retain,nonatomic) id <hotCityButtonClickDelegate> hotDelegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (void)button:(UIButton *)button selected:(BOOL)selected;

@end

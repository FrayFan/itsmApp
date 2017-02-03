//
//  SelectActionView.m
//  itsmApp
//
//  Created by admin on 2016/12/5.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "SelectActionView.h"

@interface SelectActionView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SelectActionView
{
    NSArray *celltitleArray;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        UIView *bottomView = [self viewWithTag:555];
        bottomView.layer.cornerRadius = 12;
        bottomView.layer.masksToBounds = YES;
        
        UITableView *selectTableView = [self viewWithTag:666];
        selectTableView.layer.masksToBounds = YES;
        selectTableView.separatorInset = UIEdgeInsetsMake(0, -100, 0, 0);
        selectTableView.scrollEnabled = NO;
        
        celltitleArray = @[@"全部",@"已提交",@"进行中",@"已完成",@"已关闭",@"暂停服务",@"已取消"];
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECTCELL"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SELECTCELL"];
    }

    cell.textLabel.text = celltitleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithRed:8/255.0 green:8/255.0 blue:8/255.0 alpha:1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delagate removeGrayCoverView];
    [self.delagate changeRightButtonTitle:celltitleArray[indexPath.row] withIndex:indexPath.row];
    
}


@end

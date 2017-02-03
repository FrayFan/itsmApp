//
//  StateTableView.m
//  itsmApp
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "StateTableView.h"
#import "UserHeadView.h"
#import "StateTableViewCell.h"
#import "UIView+Additions.h"
#import "FFLabel.h"
#import "common.h"

@implementation StateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;

        //设置全部单元格点击效果
        [self setAllowsSelection:NO];
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self;
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _processMoedl.nodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateCell"];
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"StateTableViewCell" owner:nil options:nil].lastObject;
    }
    
    if (_processMoedl.nodesModels.count>0) {
        _nodesModel = _processMoedl.nodesModels[indexPath.row];
        cell.nodesModel = _nodesModel;
    }
    cell.lastCellIndex = _processMoedl.nodes.count-1;
    cell.indexPath = indexPath;
    
    //小圆点
    UIView *circlePoint = [cell viewWithTag:350];
    circlePoint.layer.cornerRadius = 5;
    circlePoint.layer.masksToBounds = YES;
    //绿色圆点
    UIImageView *bigCircle = [cell viewWithTag:500];
    //服务文字信息
    UILabel *lable = [cell viewWithTag:600];
    lable.text = _nodesModel.processAbstract;
    
    //处理竖线、文字、圆点
    if (indexPath.row == 0) {
        
        bigCircle.hidden = NO;
        circlePoint.hidden = YES;
        lable.textColor = [UIColor blackColor];
        lable.numberOfLines = 0;
    }else if (indexPath.row == 9){
        //去除分割线
        circlePoint.hidden = NO;
        bigCircle.hidden = YES;
        lable.numberOfLines = 0;
        lable.textColor = ContentColor;
    }else{

        circlePoint.hidden = NO;
        bigCircle.hidden = YES;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = ContentColor;
        lable.numberOfLines = 0;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        
        return 60+_nodesModel.firstContentHeight;
    }else{
        
        return 60+_nodesModel.OtherContentHeight;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_orderModel.ticketStatus isEqualToString:@"已提交"]||
        ((![_orderModel.isAccepted integerValue])&&
         [_orderModel.ticketStatus isEqualToString:@"已取消"])||
        [_orderModel.ticketStatus isEqualToString:@"已受理"]||
        ![_orderModel.isAccepted integerValue]) {
        
        return 0;
    }else{
        return 130;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(void)setProcessMoedl:(ProcessModel *)processMoedl
{
    _processMoedl = processMoedl;
    
}

-(void)setOrderModel:(OrdersModel *)orderModel
{
    _orderModel = orderModel;
    
}


@end

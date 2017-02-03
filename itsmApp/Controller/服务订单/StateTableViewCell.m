//
//  StateTableViewCell.m
//  itsmApp
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "StateTableViewCell.h"
#import "UIView+Additions.h"
#import "common.h"

@interface StateTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bigCircle;//绿色圆圈
@property (weak, nonatomic) IBOutlet UIView *circleView;//圆点
@property (weak, nonatomic) IBOutlet UILabel *progressLable;//进度信息
@property (strong,nonatomic) UIView *line;//竖线
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopConstaint;//竖线顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineBottomConstaint;//竖线底部约束

@end

@implementation StateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _circleView.tag = 350;
    _bigCircle.tag = 500;
    _progressLable.tag = 600;
    _line = [self viewWithTag:400];
    
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
        
    if (_indexPath.row == 0) {
        _lineTopConstaint.constant = 30;
        _lineBottomConstaint.constant = 0;
        self.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
        
    }else if (_indexPath.row == _lastCellIndex){
        
        _lineTopConstaint.constant = 0;
        _lineBottomConstaint.constant = 35+_nodesModel.OtherContentHeight;
        self.separatorInset = UIEdgeInsetsMake(0, KScreenWidth, 0, 0);
    }else{
        
        _lineTopConstaint.constant = 0;
        _lineBottomConstaint.constant = 0;
        self.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    }
    if (_lastCellIndex == 0) {
        
        _lineTopConstaint.constant = 0;
        _lineBottomConstaint.constant = 200;
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

-(void)setNodesModel:(NodesModel *)nodesModel
{
    _nodesModel = nodesModel;
    _progressLable.text = nodesModel.processAbstract;
    _date.text = nodesModel.processTime;
    
    
}



@end

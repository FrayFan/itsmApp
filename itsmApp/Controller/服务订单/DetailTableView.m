//
//  DetailTableView.m
//  itsmApp
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "DetailTableView.h"
#import "FirstdetailViewCell.h"
#import "SeconddetailViewCell.h"
#import "SecondVoiceCell.h"
#import "ThirddetailViewCell.h"
#import "FFLabel.h"
#import "UIView+Additions.h"
#import "common.h"

#define EngineerModel [_detailModel.identity isEqualToString:@"02"]

@implementation DetailTableView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self setSeparatorColor:LightGrayColor];
        [self setAllowsSelection:NO];
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = LightGrayColor;
        
        //适配iPhone5
        if (KScreenWidth<375) {
            self.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        }
        
        //监听键盘弹起
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewPosition:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
    
}

#pragma - mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"TABLECELL"];
    FirstdetailViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"FIRSTCELL"];
    SeconddetailViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:@"SECONDCELL"];
    SecondVoiceCell *secondVoiceCell = [tableView dequeueReusableCellWithIdentifier:@"SECONDVOICE"];
    ThirddetailViewCell *thirdCell = [tableView dequeueReusableCellWithIdentifier:@"THIRDCELL"];
    
    if (firstCell == nil) {
        tableCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TABLECELL"];
        firstCell = [[NSBundle mainBundle] loadNibNamed:@"FirstdetailViewCell" owner:nil options:nil].lastObject;
        secondCell = [[NSBundle mainBundle] loadNibNamed:@"SeconddetailViewCell" owner:nil options:nil].lastObject;
        secondVoiceCell = [[NSBundle mainBundle] loadNibNamed:@"SecondVoiceCell" owner:nil options:nil].lastObject;
        thirdCell = [[NSBundle mainBundle] loadNibNamed:@"ThirddetailViewCell" owner:nil options:nil].lastObject;
    }
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 200)];
    
    if (indexPath.row == 0) {
        
        UILabel *lable = [firstCell viewWithTag:222];
        lable.numberOfLines = 0;
        lable.height = _detailModel.contentHeight;
        firstCell.firstDetailModel = EngineerModel?_engineerModel:_detailModel;
        if (![_detailModel.picturesURL isKindOfClass:[NSArray class]]) {
            if (![_detailModel.voidceURL isKindOfClass:[NSArray class]]) {
                firstCell.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
            }else{
                firstCell.separatorInset = UIEdgeInsetsMake(0, KScreenWidth, 0, 0);
            }
            
        }
        return firstCell;
    }else if (indexPath.row == 1){
        
        secondCell.secondDetailModel = EngineerModel?_engineerModel:_detailModel;
        if (![secondCell.secondDetailModel.picturesURL isKindOfClass:[NSArray class]]) {
            secondCell.picCollectionView.hidden = YES;

        }else{
            secondCell.picCollectionView.hidden = NO;
        }
        if ([secondCell.secondDetailModel.voidceURL isKindOfClass:[NSArray class]]) {
            secondCell.separatorInset = UIEdgeInsetsMake(0, KScreenWidth, 0, 0);
        }
        
        return secondCell;
    }else if (indexPath.row == 2){
        
         secondVoiceCell.voiceDetailModel = EngineerModel?_engineerModel:_detailModel;
        if (![secondVoiceCell.voiceDetailModel.voidceURL isKindOfClass:[NSArray class]]) {
            secondVoiceCell.hidden = YES;
        }else{
            secondVoiceCell.hidden = NO;
        }
        return secondVoiceCell;
    }
    else if (indexPath.row == 3){
        
        thirdCell.thirddetailModel = EngineerModel?_engineerModel:_detailModel;
        if ([_detailModel.ticketStatus isEqualToString:@"已提交"]||
            _detailModel.engineerModel.engineerName == nil) {
            thirdCell.phoneIcon.hidden = YES;
        }
        return thirdCell;
        
    }else if (indexPath.row == 4){
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 8)];
        grayView.backgroundColor = LightGrayColor;
        [tableCell addSubview:grayView];
        return tableCell;
    }else if (indexPath.row == 5){
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, KScreenWidth-30, 13)];
        lable.text = @"工程师提交方案";
        [tableCell addSubview:lable];
        if (_hidden) {
                
            lable.hidden = YES;
        }else{
            lable.hidden = NO;
        }
        return tableCell;
        
    }else{
        UILabel *waterLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 15)];
        waterLable.text = @"请输入文字";
        waterLable.textColor = ContentColor;
        waterLable.textAlignment = NSTextAlignmentLeft;
        waterLable.font = [UIFont systemFontOfSize:15];
        waterLable.tag = 22;
        
        _textView.tag = 2000;
        _textView.delegate =self;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = ContentColor;
        [tableCell addSubview:_textView];
        [_textView addSubview:waterLable];
        
        if (EngineerModel) {
            //工程师单据模块
            _textView.editable = NO;
            _textView.hidden = NO;
            _textView.text = _engineerModel.engineerSolution;
            if ([_engineerModel.ticketStatus isEqualToString:@"进行中"]){
                _textView.editable = YES;
            }
            if (![_engineerModel.engineerSolution isEqualToString:@""]) {
                waterLable.hidden = YES;
            }

        }else{
            //用户模块
            _textView.editable = NO;
            _textView.text = _detailModel.engineerSolution;
            waterLable.hidden = YES;

        }
        
        if (_hidden) {
            _textView.hidden = YES;
        }

        //去除分割线
        tableCell.separatorInset = UIEdgeInsetsMake(0, KScreenWidth, 0, 0);
        return tableCell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat engCotentHeight = 0;
    CGFloat userContentHeight = 0;
    NSInteger engPicCount = 0;
    NSInteger userPicCount = 0;
    
    if (EngineerModel) {
        engCotentHeight = _engineerModel.contentHeight;
        if ([_engineerModel.picturesURL isKindOfClass:[NSArray class]]) {
            engPicCount = _engineerModel.picturesURL.count;
        }

    }else{
        userContentHeight = _detailModel.contentHeight;
        if ([_detailModel.picturesURL isKindOfClass:[NSArray class]]) {
            userPicCount = _detailModel.picturesURL.count;

        }
    }
    
    if (indexPath.row == 0) {
        CGFloat cellHeight = 80;
        if (_detailModel.content.length>19&&_detailModel.content.length<39) {
            cellHeight+= 5;
        }
        return cellHeight+ (EngineerModel?engCotentHeight:userContentHeight);
        
    }else if (indexPath.row == 1){
        
        CGFloat cellHeight = 0;
        CGFloat height = [SeconddetailViewCell cellHeight:(EngineerModel?engPicCount:userPicCount)];
        if ([_detailModel.picturesURL isKindOfClass:[NSArray class]]) {
            cellHeight = height;
        }
        return cellHeight;
        
        
    }else if (indexPath.row == 2){
        
        CGFloat cellHeight = 0;
        if ([_detailModel.voidceURL isKindOfClass:[NSArray class]]) {
            cellHeight = 55;
        }
        return cellHeight;
        
    }else if (indexPath.row == 3){
        
        CGFloat height = [ThirddetailViewCell thirdCellHeight];
        return height;
        
    }else if (indexPath.row == 4){
        return 8;
        
    }else if (indexPath.row == 5){
        
        CGFloat height = [ThirddetailViewCell thirdCellHeight];
        
        return _hidden?0:height;
        
    }else{
        
        return _hidden?0:300;
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textView resignFirstResponder];
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];

     UILabel *waterLable = [_textView viewWithTag:22];
    if (_textView.text.length != 0) {
        //隐藏水印文字
        waterLable.hidden = YES;
    }else{
        
        waterLable.hidden = NO;
    }

    
}

//弹起、收起键盘
- (void)changeViewPosition:(NSNotification *)notification
{
     CGRect keyframe = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (![_detailModel.picturesURL isKindOfClass:[NSArray class]]||
        ![_detailModel.voidceURL isKindOfClass:[NSArray class]]) {
        
        keyframe.size.height -= 200;
    }
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0,-keyframe.size.height);
    }];
    
    //隐藏水印文字
    UILabel *waterLable = [_textView viewWithTag:22];
    waterLable.hidden = YES;
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
    [_textView resignFirstResponder];
    if (![_textView isExclusiveTouch]) {
        
        UILabel *waterLable = [_textView viewWithTag:22];

        if (_textView.text.length != 0) {
            //隐藏水印文字
            waterLable.hidden = YES;
        }else{
            
            waterLable.hidden = NO;
        }
        
    }
    
}

-(void)setDetailModel:(DetailModel *)detailModel
{
    _detailModel = detailModel;
    if (EngineerModel) {
        _engineerModel = _detailModel;
    }
    
    //是否隐藏工程师方案模块
    _hidden = [_detailModel.ticketStatus isEqualToString:@"已提交"]||
    [_detailModel.ticketStatus isEqualToString:@"已受理"]||
    (_detailModel.engineerModel.engineerName == nil)||
    (!EngineerModel&&[_detailModel.engineerSolution isEqualToString:@""])||
    (EngineerModel&&![_detailModel.ticketStatus isEqualToString:@"进行中"]&&
     [_detailModel.engineerSolution isEqualToString:@""])||
    (![_detailModel.orginalType isEqualToString:@"手机APP"]);

}

#pragma  mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>= 180) {
        return NO;
    }else{
        return YES;
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    _textView.text = textView.text;
}


@end

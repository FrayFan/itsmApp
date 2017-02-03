//
//  MyFBDetailController.m
//  itsmApp
//
//  Created by admin on 2017/1/5.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "MyFBDetailController.h"
#import "MyFeedbackCell.h"
#import "PictureFBCell.h"
#import "UIView+Additions.h"
#import "common.h"

@interface MyFBDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


- (IBAction)backAction:(id)sender;
@end

@implementation MyFBDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"TABLEVIEW"];
    MyFeedbackCell *myFBCell = [tableView dequeueReusableCellWithIdentifier:@"MYFBCELL"];
    PictureFBCell *picFBCell = [tableView dequeueReusableCellWithIdentifier:@"PICFBCELL"];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TABLEVIEW"];
        myFBCell = [[NSBundle mainBundle] loadNibNamed:@"MyFeedbackCell" owner:nil options:nil].lastObject;
        picFBCell = [[NSBundle mainBundle] loadNibNamed:@"PictureFBCell" owner:nil options:nil].lastObject;
    }
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myFBCell.selectionStyle = UITableViewCellSelectionStyleNone;
    picFBCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        myFBCell.feedBackModel = _FBModel;
        myFBCell.content.numberOfLines = 0;
        myFBCell.content.height = _FBModel.contentHeight;
        return myFBCell;
    }else if (indexPath.row == 1){
        picFBCell.myFBModel = _FBModel;
        return picFBCell;
    }else{
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 1,KScreenWidth , .5)];
        line.backgroundColor = LightGrayColor;
        [tableViewCell addSubview:line];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 16, 30, 25)];
        imageView.image = [UIImage imageNamed:@"customService_pic"];
        [tableViewCell addSubview:imageView];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(55, 17, 100, 21)];
        lable.text = @"客服";
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = BlueColor;
        [tableViewCell addSubview:lable];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(15, 55, KScreenWidth-30, 500)];
        [tableViewCell addSubview:content];
        content.text = _FBModel.processContent;
        content.numberOfLines = 0;
        content.height = _FBModel.proContentHeight;
        
        return tableViewCell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55+_FBModel.contentHeight;
    }else if (indexPath.row == 1){
        CGFloat cellHeight = 0;
        if ([_FBModel.pictureURL isKindOfClass:[NSArray class]]) {
            cellHeight = 120;
        }
        return cellHeight;
    }else{
        return 500;
    }
}

- (void)setFBModel:(MyFeedbackModel *)FBModel
{
    _FBModel = FBModel;
}


- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

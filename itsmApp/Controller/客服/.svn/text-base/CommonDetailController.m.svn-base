//
//  CommonDetailController.m
//  itsmApp
//
//  Created by admin on 2016/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "CommonDetailController.h"
#import "GetFAQDetailHandle.h"
#import "common.h"
#import "UIView+Additions.h"

@interface CommonDetailController ()<UITableViewDataSource,UITableViewDelegate,NetworkHandleDelegate>

@property (nonatomic,strong) GetFAQDetailHandle *detailHandle;

- (IBAction)backAction:(id)sender;//返回
@end

@implementation CommonDetailController
{
    UITableView *detailTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    detailTableView = [self.view viewWithTag:220];
    detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    detailTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 8)];
    detailTableView.tableHeaderView.backgroundColor = LightGrayColor;
    detailTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DETAILCELL"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DETAILCELL"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, KScreenWidth-30, 30)];
    
    [cell addSubview:content];
    
    FAQDetailModel *detailModel = _detailHandle.FAQModels[0];
    if (indexPath.row == 0) {
        
        content.font = [UIFont systemFontOfSize:17];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        content.text = detailModel.FAQTitle;
    }else{
        
        content.numberOfLines = 0;
        content.font = [UIFont systemFontOfSize:15];
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenWidth, 0, 0);
        content.text = detailModel.FAQContent;
        content.height = detailModel.contentHeight;
        content.textColor = ContentColor;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 50;
    }else{
        
        return 200;
    }

}

#pragma  mark - NetworkHandleDelegate

- (void)successed:(id)handle response:(id)response
{
    if (handle == _detailHandle) {
        
        [detailTableView reloadData];
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    
}

-(void)setFAQlistModel:(FAQListModel *)FAQlistModel
{
    _FAQlistModel = FAQlistModel;
    
    //发送FAQ详情请求
    _detailHandle = [[GetFAQDetailHandle alloc]init];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_detailHandle.requestObj.d];
    [tempDic setObject:_FAQlistModel.FAQID forKey:@"FID"];
    _detailHandle.requestObj.d = tempDic;
    [_detailHandle sendRequest];
    _detailHandle.delegate = self;
}


- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

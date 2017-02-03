//
//  ServiceViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/17.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceTableViewCell.h"
#import "ProblemOrderController.h"
#import "AppealProgressController.h"
#import "CommonProController.h"
#import "FeedbackController.h"
#import "ContactServiceController.h"
#import "ImagePickerHandler.h"

@interface ServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

- (IBAction)backToHome:(id)sender;//返回

@end

@implementation ServiceViewController
{
    NSArray *cellTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *serviceTableView = [self.view viewWithTag:770];
    serviceTableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    serviceTableView.backgroundColor = [UIColor clearColor];
    serviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    serviceTableView.scrollEnabled = NO;
    serviceTableView.delegate = self;
    serviceTableView.dataSource = self;
    
    cellTitles = @[@"某一笔服务单遇到问题",@"投诉进度查询",@"反馈建议",@"常见问题",@"联系客服"];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SERVICECELL"];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"ServiceTableViewCell" owner:nil options:nil].lastObject;
    }
    UILabel *title = [cell viewWithTag:880];
    title.text = cellTitles[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {//某一笔问题订单
            ProblemOrderController *problemC = [[NSBundle mainBundle] loadNibNamed:@"ProblemOrderController" owner:nil options:nil].lastObject;
            [self.navigationController pushViewController:problemC animated:YES];
        }
            break;
        case 1:
        {//投诉进度查询
            AppealProgressController *progressC = [[NSBundle mainBundle]loadNibNamed:@"AppealProgressController" owner:nil options:nil].lastObject;
            [self.navigationController pushViewController:progressC animated:YES];
            
        }
            break;
        case 2:
        {//意见反馈
            FeedbackController *feedbackC = [[NSBundle mainBundle] loadNibNamed:@"FeedbackController" owner:nil options:nil].lastObject;
            [self.navigationController pushViewController:feedbackC animated:YES];
        }
            break;
        case 3:
        {//常见问题
            CommonProController *commonC = [[NSBundle mainBundle] loadNibNamed:@"CommonProController" owner:nil options:nil].lastObject;
            [self.navigationController pushViewController:commonC animated:YES];
            
        }
            break;
            
        default:
        {//联系客服
            ContactServiceController *contactC = [[NSBundle mainBundle] loadNibNamed:@"ContactServiceController" owner:nil options:nil].lastObject;
            [self.navigationController pushViewController:contactC animated:YES];
            
        }
            break;
    }
}


- (IBAction)backToHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

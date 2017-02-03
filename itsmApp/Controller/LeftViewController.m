//
//  LeftViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/15.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "RefreshInfoHandle.h"
#import "GetUserInfoHandle.h"
#import "UIImageView+EMMFileCache.h"


@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *iconNameArray;
    NSArray *itemNameArray;
    NSInteger itemCount;
}
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
- (IBAction)settingAction:(id)sender;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self userInfoDidChange];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMessageDidChange) name:UnReadMessageDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidChange) name:UserInfoDidUpdateNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshItemWithEngineer:(BOOL)engineer
{
    itemNameArray = @[@"服务订单",@"信息",@"客服",@"工程师单据管理"];
    iconNameArray = @[@"order_icon",@"info_icon",@"service_icon",@"bills_icon"];
    if (engineer) {
        itemCount = 4;
    }
    else
    {
        itemCount = 3;
    }
    [self.leftTableView reloadData];
}

- (void)unreadMessageDidChange
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.leftTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)userInfoDidChange
{
    UserBaseInfo *info = [UserBaseInfo share];
    [self.headerImageView emm_setImageWithURL:[NSURL URLWithString:info.headerUrl ?:@""] placeholderImage:[UIImage imageNamed:@"default_face"]];
    self.nameLabel.text = info.userName ?:@"";
    self.userIdLabel.text = info.userId ?:@"";
    [self refreshItemWithEngineer:[info isEngineer]];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leftIdentify"];
    cell.itemLabel.text = itemNameArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:iconNameArray[indexPath.row]];
    cell.unreadView.hidden = YES;
    if (indexPath.row == 1 && [UnreadMessage share].unreadCount > 0) {
        cell.unreadView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *controller = nil;
    switch (indexPath.row) {
        case 0://服务订单
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"order" bundle:nil];
            controller = [storyboard instantiateInitialViewController];
        }
            break;
        case 1://信息
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"info" bundle:nil];
            controller = [storyboard instantiateInitialViewController];
        }
            break;
        case 2://客服
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"service" bundle:nil];
            controller = [storyboard instantiateInitialViewController];
        }
            break;
        case 3://工程师单据管理
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"bills" bundle:nil];
            controller = [storyboard instantiateInitialViewController];
        }
            break;
        default:
            break;
    }
    
    if (controller)
    {
        __weak typeof(self) wself = self;
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [(UINavigationController *)wself.mm_drawerController.centerViewController pushViewController:controller animated:NO];
        }];
    }
}

- (IBAction)settingAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"setting" bundle:nil];
    UIViewController *controller = [storyboard instantiateInitialViewController];
    __weak typeof(self) wself = self;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [(UINavigationController *)wself.mm_drawerController.centerViewController pushViewController:controller animated:NO];
    }];
    
}
@end

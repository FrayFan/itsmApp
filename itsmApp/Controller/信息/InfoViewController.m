//
//  InfoViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/17.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoTableViewCell.h"
#import "MessagesHandle.h"
#import "MJRefresh.h"

@interface InfoViewController ()<UITableViewDelegate,UITableViewDataSource,NetworkHandleDelegate>
@property (nonatomic,strong)MessagesHandle *messagesHandle;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (nonatomic,assign)CGFloat maxWidth;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messagesHandle = [[MessagesHandle alloc] init];
    self.messagesHandle.delegate = self;
    [self.messagesHandle buildRefreshMessage];
    [self.messagesHandle sendRequest];
    
    self.maxWidth = [UIScreen mainScreen].bounds.size.width - 15.0 - 44.0 - 25.0 - 15.0;
    
    __weak typeof(self) weakSelf = self;
    self.infoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.messagesHandle buildRefreshMessage];
            [strongSelf.messagesHandle sendRequest];
        }
        else
        {
            
        }
    }];
    
    self.infoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.messagesHandle buildLoadMoreMessage];
            [strongSelf.messagesHandle sendRequest];
        }
        else
        {
            
        }
    }];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesHandle.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoIdentify"];
    MessageObject *msg = self.messagesHandle.messages[indexPath.row];
    cell.infoLabel.text = msg.messageContent;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageObject *msg = self.messagesHandle.messages[indexPath.row];
    CGFloat height = MAX(msg.contentHeight + 15.0 + 15.0, 75.0);
    return height;
}

#pragma mark NetworkingHandleDelegate

- (void)successed:(id)handle response:(id)response
{
    if (handle == self.messagesHandle) {
        
        for (MessageObject * msg in self.messagesHandle.resultList) {
            msg.contentHeight = [MessageObject calculateSizeWithContent:msg.messageContent maxWidth:self.maxWidth font:[UIFont systemFontOfSize:15.0]].height;
            msg.contentHeight = ceilf(msg.contentHeight);
        }
        
        [self.infoTableView reloadData];
        [self.infoTableView.mj_header endRefreshing];
        [self.infoTableView.mj_footer endRefreshing];
        
        if (self.messagesHandle.haveMore == NO) {
            [self.infoTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    if (handle == self.messagesHandle) {
        [self.infoTableView.mj_header endRefreshing];
        [self.infoTableView.mj_footer endRefreshing];
    }
}


@end

//
//  SubmitFinishedViewController.m
//  itsmApp
//
//  Created by itp on 2017/1/17.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "SubmitFinishedViewController.h"

@interface SubmitFinishedViewController ()
- (IBAction)goHomeAction:(id)sender;
- (IBAction)goProcessAction:(id)sender;

@end

@implementation SubmitFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)goHomeAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showHomePage)]) {
        [self.delegate showHomePage];
    }
    
}

- (IBAction)goProcessAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showBillsProcessPage)]) {
        [self.delegate showBillsProcessPage];
    }
    
}
@end

//
//  SettingGestureViewController.m
//  itsmApp
//
//  Created by ZTE on 16/12/26.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "SettingGestureViewController.h"
#import "UIColor+HEX.h"
#import "Utils.h"
#import "GesturePasswordController.h"

@interface SettingGestureViewController ()
{

}
@end

@implementation SettingGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改手势密码";
    
    self.view.backgroundColor= [UIColor getColor:@"f4f4f4"];
    // Do any additional setup after loading the view from its nib.
    UIButton *leftButton = [Utils leftButtonWithTitleAndImage:@"返回"];
    [leftButton addTarget:self action:@selector(singleReturn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    // Do any additional setup after loading the view.
}
-(void)singleReturn:(id)senger
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)btnCkick:(id)sender {
    
    GesturePasswordController *gestureController = [[GesturePasswordController alloc] initWithNibName:@"GesturePasswordController" bundle:nil];
    gestureController.type = GesturePasswordTypeSetting;
    gestureController.showNavigationBar = YES;
    gestureController.title = @"设置手势密码";
    __weak typeof(self) wself = self;
    gestureController.completionBlock = ^{[wself.navigationController popViewControllerAnimated:YES];};
    [self.navigationController pushViewController:gestureController animated:YES];
}


@end

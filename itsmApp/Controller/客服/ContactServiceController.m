//
//  ContactServiceController.m
//  itsmApp
//
//  Created by admin on 2016/12/14.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ContactServiceController.h"

@interface ContactServiceController ()

- (IBAction)backAction:(id)sender;//返回

@end

@implementation ContactServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *firstButton = [self.view viewWithTag:111];
    firstButton.layer.cornerRadius = 25;
    firstButton.layer.masksToBounds = YES;
    [firstButton addTarget:self action:@selector(callingActionWithNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *seconButton = [self.view viewWithTag:222];
    seconButton.layer.cornerRadius = 25;
    seconButton.layer.masksToBounds = YES;
    [seconButton addTarget:self action:@selector(callingActionWithNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *thirdButton = [self.view viewWithTag:333];
    thirdButton.layer.cornerRadius = 25;
    thirdButton.layer.masksToBounds = YES;
    [thirdButton addTarget:self action:@selector(callingActionWithNumber:) forControlEvents:UIControlEventTouchUpInside];
}

//调用电话
- (void)callingActionWithNumber:(UIButton *)button
{
    
    switch (button.tag) {
        case 111:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",button.titleLabel.text]]];
            
        }
            break;
        case 222:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",button.titleLabel.text]]];
        }
            break;
        case 333:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",button.titleLabel.text]]];
        }
            break;
            
        default:
            break;
    }
    
}


- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

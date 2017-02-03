//
//  TimerPickerViewController.m
//  itsmApp
//
//  Created by itp on 2016/12/5.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "TimerPickerViewController.h"

@interface TimerPickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *timePickerView;

- (IBAction)cancelAction:(id)sender;


- (IBAction)okAction:(id)sender;

@end

@implementation TimerPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timePickerView.minimumDate = [NSDate date];
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

- (IBAction)cancelAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(timerPicker:finished:)]) {
        [self.delegate timerPicker:self finished:NO];
    }
    
}

- (IBAction)okAction:(id)sender {
    
    self.selectedDate = self.timePickerView.date;
    if ([self.delegate respondsToSelector:@selector(timerPicker:finished:)]) {
        [self.delegate timerPicker:self finished:YES];
    }
    
}
@end

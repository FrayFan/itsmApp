//
//  PickerContainerViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/15.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "PickerContainerViewController.h"

@interface PickerContainerViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@end

@implementation PickerContainerViewController

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

- (void)reloadPickerData
{
    [self.pickerView reloadAllComponents];
}

- (void)setServiceName:(NSString *)serviceName
{
    if (_serviceName == serviceName) {
        return;
    }
    _serviceName = [serviceName copy];
    self.serviceTitleLabel.text = _serviceName;
}

- (IBAction)cancelAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(pickerContainer:finished:)]) {
        [self.delegate pickerContainer:self finished:NO];
    }
    
}

- (IBAction)okAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(pickerContainer:finished:)]) {
        [self.delegate pickerContainer:self finished:YES];
    }
    
}
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.delegate numberOfComponent];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45.0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.delegate titleForRow:row];
}

@end

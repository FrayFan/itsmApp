//
//  FeedbackPickerView.m
//  itsmApp
//
//  Created by admin on 2016/12/15.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "FeedbackPickerView.h"
#import "UIView+Additions.h"
#import "UIView+ViewController.h"
#import "FeedbackTitleView.h"
#import "GetServiceHandle.h"

@interface FeedbackPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation FeedbackPickerView
{
    FeedbackTitleView *titleView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tag = 1234;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return _service.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ServiceCatalog *catalog = _service[row];
    return catalog.name;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    titleView = [self.superview viewWithTag:450];
    ServiceCatalog *catalog = _service[row];
    titleView.titleLable.text = catalog.name;
    titleView.serviceId = catalog.serviceId;
}

@end

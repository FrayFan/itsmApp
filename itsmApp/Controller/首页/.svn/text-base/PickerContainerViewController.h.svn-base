//
//  PickerContainerViewController.h
//  itsmApp
//
//  Created by itp on 2016/11/15.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerContainerViewController;

@protocol PickerContainerDelegate <NSObject>

- (void)pickerContainer:(PickerContainerViewController *)controller finished:(BOOL)finished;

- (NSInteger)numberOfComponent;

- (NSString *)titleForRow:(NSInteger)row;

@end

@interface PickerContainerViewController : UIViewController
@property (nonatomic,copy)NSString *serviceName;
@property (nonatomic,weak)id<PickerContainerDelegate> delegate;
@property (nonatomic,assign)NSInteger selectedRow;

- (void)reloadPickerData;

@end

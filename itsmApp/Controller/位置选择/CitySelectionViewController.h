//
//  CitySelectionViewController.h
//  itsmApp
//
//  Created by ZTE on 16/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAddress @"address"
#define kCity   @"city"
#define kCityId @"cityId"

#define kLatestAddress @"latestAddress"
#define kLatestCity   @"latestCity"
#define kLatestCityId @"latestCityId"

@protocol CityAddressDelegate<NSObject>
@optional
-(void)getSelectCity:(NSDictionary *)cityDict;//1.1定义协议与方法
@end


@interface CitySelectionViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    
    UIView *baseView;
    UIView *_pickerView;
    
    UIPickerView *picker;
    
    UIView *_selectShowView;

}

@property (retain,nonatomic) id <CityAddressDelegate> selDelegate;

+ (NSString *)latestCity;

+ (NSString *)latestAddress;

+ (NSString *)latestCityId;


@end

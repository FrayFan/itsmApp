//
//  CityInfo.h
//  itsmApp
//
//  Created by itp on 2017/1/9.
//  Copyright © 2017年 itp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *cityName;
@property (nonatomic,copy)NSString *cityEnName;
@property (nonatomic,strong)NSArray *childs;

@property (nonatomic,strong)NSString *firstLetter;
//@property (nonatomic,strong)NSString *pinyin;

+ (CityInfo *)buildCityInfo:(NSDictionary *)cityDict;

- (void)pinyinProcess;

@end

@interface HotCityInfo : NSObject
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *cityName;
@property (nonatomic,assign)NSInteger levelId;
@property (nonatomic,copy)NSString *cityEnName;

- (id)initWithDictionary:(NSDictionary *)dict;

@end

//
//  CityInfo.m
//  itsmApp
//
//  Created by itp on 2017/1/9.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "CityInfo.h"
#import "PinYinString.h"

@implementation CityInfo

+ (CityInfo *)buildCityInfo:(NSDictionary *)cityDict
{
    CityInfo *cityInfo = [[CityInfo alloc] init];
    cityInfo.cityId = [NSString stringWithFormat:@"%@",cityDict[@"id"]?:@""];
    cityInfo.cityName = cityDict[@"name"];
    cityInfo.cityEnName = cityDict[@"pyName"];
    NSArray *childCityArray = cityDict[@"childs"];
    if (childCityArray.count > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *childCityDict in childCityArray) {
            [tempArray addObject:[self buildCityInfo:childCityDict]];
        }
        cityInfo.childs = [NSArray arrayWithArray:tempArray];
    }
    return cityInfo;
}

- (void)pinyinProcess
{
    self.firstLetter = [[PinYinString firstLetter:self.cityName] uppercaseString];
//    self.pinyin = [[PinYinString pinyin:self.cityName] uppercaseString];
}

@end

@implementation HotCityInfo

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _cityName = dict[@"name"];
        _cityId = [NSString stringWithFormat:@"%@",dict[@"id"]?:@""];
        _levelId = [dict[@"levelId"] integerValue];
        _cityEnName = dict[@"pyName"];
    }
    return self;
}

@end


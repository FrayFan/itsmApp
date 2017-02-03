//
//  PHAsset+Latest.m
//  itsmApp
//
//  Created by itp on 2016/12/3.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "PHAsset+Latest.h"

@implementation PHAsset (Latest)

+ (NSArray *)latestAssetsWithTimeInterval:(NSTimeInterval)timeInterval count:(NSInteger)count
{
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceNow:(-timeInterval)];
    NSPredicate *predicate_date = [NSPredicate predicateWithFormat:@"creationDate >= %@ ",beginDate];
    options.predicate = predicate_date;
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [assetsFetchResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= count) {
            *stop = YES;
        }
        else
        {
            [temp addObject:obj];
        }
    }];
    
    return [NSArray arrayWithArray:temp];
}

@end

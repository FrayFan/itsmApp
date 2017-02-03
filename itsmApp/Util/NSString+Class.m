//
//  NSString+Class.m
//  itsmApp
//
//  Created by admin on 2016/12/21.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "NSString+Class.h"

@implementation NSString (Class)


+ (NSString *)integerMakeString:(NSInteger)integer
{
    NSNumber *inNumber = [NSNumber numberWithInteger:integer];
    NSString *dString = [NSString stringWithFormat:@"%@",inNumber];
    
    return dString;
}


@end

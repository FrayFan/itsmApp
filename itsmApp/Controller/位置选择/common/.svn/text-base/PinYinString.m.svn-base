//
//  PinYinString.m
//  itsmApp
//
//  Created by itp on 2017/1/9.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "PinYinString.h"
#import "pinyin.h"

@implementation PinYinString

+ (NSString *)firstLetter:(NSString *)string
{
    if ([string length] >= 1) {
        if ([[(NSString *)string substringToIndex:1] compare:@"长"] == NSOrderedSame)
        {
            return @"c";
        }
        else if ([[(NSString *)string substringToIndex:1] compare:@"沈"] == NSOrderedSame)
        {
            return @"s";
        }
        else if ([[(NSString *)string substringToIndex:1] compare:@"厦"] == NSOrderedSame)
        {
            return @"x";
        }
        else if ([[(NSString *)string substringToIndex:1] compare:@"地"] == NSOrderedSame)
        {
            return @"d";
        }
        else if ([[(NSString *)string substringToIndex:1] compare:@"重"] == NSOrderedSame)
        {
            return @"c";
        }
        else
        {
            return [NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])];
        }
    }
    return nil;
}

//+ (NSString *)pinyin:(NSString *)string
//{
//    if ([string length] >= 1) {
//        NSMutableString *tempString = [[NSMutableString alloc] initWithCapacity:[string length]];
//        for (int i = 0; i < [string length]; i++) {
//            unichar stringChar = [string characterAtIndex:i];
//            [tempString stringByAppendingFormat:@"%c",pinyinFirstLetter(stringChar)];
//        }
//        return [NSString stringWithString:tempString];
//    }
//    return nil;
//}

@end

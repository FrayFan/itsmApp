//
//  GetCityWorkingHandle.m
//  itsmApp
//
//  Created by ZTE on 16/12/20.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetCityWorkingHandle.h"
#import "NetworkingManager.h"


@implementation GetCityWorkingHandle

- (id)init
{
    self = [super init];
    if (self) {
        NSString *ver= [[NSUserDefaults standardUserDefaults] objectForKey:@"city_ver"];
        [self.requestObj.d addEntriesFromDictionary:@{@"ver":ver ?:@"0"}];
    }
    return self;
}

+ (NSString *)commandName
{
    return @"getZTEWorkingPlaceList";
}

+ (NSString *)path
{
    return WorkingPlacePaht;
}

- (void)willHandleSuccessedResponse:(id)response
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ResponseObject *obj = response;
    NSDictionary *dict = nil;
    if ([obj.d isKindOfClass:[NSString class]]) {
        NSData *data = [obj.d dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSString *ver= [defaults objectForKey:@"city_ver"];
        NSString *new_ver=dict[@"ver"];
        if([ver intValue]!=[new_ver intValue] || ver==nil)
        {
        
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *path=[paths objectAtIndex:0];
            NSString *json_path=[path stringByAppendingPathComponent:@"working_place.json"];
            NSData *data = [obj.d dataUsingEncoding:NSUTF8StringEncoding];
            BOOL isSave=[data writeToFile:json_path atomically:YES];
            if(isSave)
            {
                [defaults setObject:new_ver forKey:@"city_ver"];
                [defaults synchronize];
            }
        }
    }
}

@end

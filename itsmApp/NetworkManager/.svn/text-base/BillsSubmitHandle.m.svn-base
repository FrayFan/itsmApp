//
//  BillsSubmitHandle.m
//  itsmApp
//
//  Created by itp on 2016/12/16.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BillsSubmitHandle.h"
#import "NetworkingManager.h"
#import "EMMSecurity.h"
#import "GetUserInfoHandle.h"

@interface BillsSubmitHandle ()
//@property (nonatomic,copy)NSString *type;
@end

@implementation BillsSubmitHandle

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSString *)commandName
{
    return @"createServiceReceipt";
}

+ (NSString *)path
{
    return BaseDataPath;
}

- (void)bulidBillsInputData
{
    [self.requestObj.d addEntriesFromDictionary:self.receiptDict ?:@{@"RID":@"",@"PICURL":@[],@"VOIURL":@[],@"ATTURL":@[]}];
    [self.requestObj.d setObject:self.billsTypeId ?:@"" forKey:@"CGID"];
    [self.requestObj.d setObject:self.content ?:@"" forKey:@"CT"];
    [self.requestObj.d setObject:[self.submitTime length] > 0 ? @"02":@"01" forKey:@"TY"];
    [self.requestObj.d setObject:self.submitTime ?:@"Now" forKey:@"SUBTM"];
    [self.requestObj.d setObject:[UserBaseInfo share].isVip ?:@"F" forKey:@"ISVIP"];
    [self.requestObj.d setObject:self.location ?:@"" forKey:@"LT"];
    [self.requestObj.d setObject:self.locationId ?:@"" forKey:@"LTID"];
    [self.requestObj.d setObject:self.audioDuration ?:@"" forKey:@"AD"];
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSArray class]]) {
        
    }
}

@end

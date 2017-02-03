//
//  GetServiceHandle.m
//  itsmApp
//
//  Created by itp on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetServiceHandle.h"
#import "NetworkingManager.h"
#import "NSDictionary+NSNull.h"

#define kServiceCatalogs    @"serviceCatalogs"

@interface GetServiceHandle ()
@property (nonatomic,strong)NSArray *serviceCatalogs;
@end

@implementation GetServiceHandle

- (id)init
{
    self = [super init];
    if (self) {
        _serviceCatalogs = [ServiceCatalog localCacheServiceCatalog];
    }
    return self;
}

+ (NSString *)commandName
{
    return @"getServiceCatalogs";
}

+ (NSString *)path
{
    return BaseDataPath;
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    NSArray *catalogs = obj.d;
    if ([catalogs isKindOfClass:[NSArray class]]) {
        NSMutableArray<ServiceCatalog *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *catalog in catalogs) {
            ServiceCatalog *service = [ServiceCatalog makeServiceCatalog:[NSDictionary nullDic:catalog]];
            [tempArray addObject:service];
        }
        self.serviceCatalogs = [NSArray arrayWithArray:tempArray];
        if ([self.serviceCatalogs count] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[self.serviceCatalogs networkingArray] forKey:kServiceCatalogs];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end


@implementation ServiceCatalog

+ (NSArray *)localCacheServiceCatalog
{
    NSArray *localCache = [[NSUserDefaults standardUserDefaults] objectForKey:kServiceCatalogs];
    if (localCache.count > 0) {
        NSMutableArray<ServiceCatalog *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *catalog in localCache) {
            ServiceCatalog *service = [ServiceCatalog makeServiceCatalog:[NSDictionary nullDic:catalog]];
            [tempArray addObject:service];
        }
        return [NSArray arrayWithArray:tempArray];
    }
    return nil;
}

+ (ServiceCatalog *)makeServiceCatalog:(NSDictionary *)dict
{
    ServiceCatalog *catalog = [[ServiceCatalog alloc] init];
    catalog.serviceId = dict[@"ID"];
    catalog.name = dict[@"NM"];
    catalog.type = dict[@"TY"];
    catalog.node = dict[@"ND"];
    catalog.parentId = dict[@"PRT"];
    catalog.descript = dict[@"DSP"];
    NSArray *scArray = dict[@"SC"];
    if ([scArray isKindOfClass:[NSArray class]] && scArray.count > 0) {
        NSMutableArray<ServiceCatalog *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *subDict in scArray) {
            ServiceCatalog *subCatalog = [self makeServiceCatalog:subDict];
            [tempArray addObject:subCatalog];
        }
        catalog.sc = [NSArray arrayWithArray:tempArray];
    }
    return catalog;
}

- (NSDictionary *)networkingDictionary
{
    return @{@"ID":self.serviceId ?:@"",
             @"NM":self.name ?:@"",
             @"TY":self.type ?:@"",
             @"ND":self.node ?:@"",
             @"PRT":self.parentId ?:@"",
             @"DSP":self.descript ?:@"",
             @"SC":self.sc ? [self.sc networkingArray]:@""};
}

@end


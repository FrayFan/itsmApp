//
//  GetServiceHandle.h
//  itsmApp
//
//  Created by itp on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"

@class ServiceCatalog;

@interface GetServiceHandle : BaseNetworkingHandle
@property (nonatomic,strong,readonly)NSArray<ServiceCatalog *> *serviceCatalogs;
@end

@interface ServiceCatalog : BaseNetworkingObject
@property (nonatomic,copy)NSString *serviceId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *node;
@property (nonatomic,copy)NSString *parentId;
@property (nonatomic,copy)NSString *descript;
@property (nonatomic,strong)NSArray<ServiceCatalog*> *sc;

+ (NSArray *)localCacheServiceCatalog;

+ (ServiceCatalog *)makeServiceCatalog:(NSDictionary *)dict;

@end

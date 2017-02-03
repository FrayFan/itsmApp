//
//  GetFAQListHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"
#import "NetworkingManager.h"

@interface GetFAQListHandle : BaseNetworkingHandle

@property (nonatomic,strong) NSMutableArray *FAQModels;
@end


@interface FAQListModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *FAQID;
@property (nonatomic,copy) NSString *FAQTitle;

+ (FAQListModel *)makeFAQModel:(NSDictionary *)dict;

@end

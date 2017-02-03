//
//  GetFAQDetailHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"
#import "NetworkingManager.h"

@interface GetFAQDetailHandle : BaseNetworkingHandle

@property (strong,nonatomic) NSMutableArray *FAQModels;
@end

@interface FAQDetailModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *FAQID;
@property (nonatomic,copy) NSString *FAQTitle;
@property (nonatomic,copy) NSString *FAQContent;

+ (FAQDetailModel *)makeDetailModel:(NSDictionary *)dict;
@property (nonatomic,assign) float contentHeight;
@end

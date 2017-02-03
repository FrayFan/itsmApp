//
//  UserFeedbackHandle.h
//  itsmApp
//
//  Created by itp on 2016/12/26.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"

@interface UserFeedbackHandle : BaseNetworkingHandle
@property (nonatomic,strong)NSString *scg;
@property (nonatomic,strong)NSString *feedback;
@property (nonatomic,strong)NSDictionary *picDict;

- (void)buildFeedbackData;

@end

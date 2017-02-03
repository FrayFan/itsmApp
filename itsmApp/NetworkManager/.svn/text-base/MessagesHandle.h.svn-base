//
//  MessagesHandle.h
//  itsmApp
//
//  Created by itp on 2016/12/21.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"

@interface MessagesHandle : BaseNetworkingHandle
@property (nonatomic,strong) NSMutableArray *messages;
@property (nonatomic,assign,readonly) BOOL haveMore;
@property (nonatomic,strong) NSArray *resultList;


- (void)buildRefreshMessage;

- (void)buildLoadMoreMessage;

@end

@interface MessageObject : BaseNetworkingObject

@property (nonatomic,copy)NSString *messageId;
@property (nonatomic,copy)NSString *messageContent;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,assign)CGFloat contentHeight;

+ (CGSize)calculateSizeWithContent:(NSString *)content maxWidth:(CGFloat)maxWidth font:(UIFont *)font;

@end

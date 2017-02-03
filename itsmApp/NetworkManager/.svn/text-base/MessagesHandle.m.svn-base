//
//  MessagesHandle.m
//  itsmApp
//
//  Created by itp on 2016/12/21.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "MessagesHandle.h"
#import "NetworkingManager.h"
#import "RefreshInfoHandle.h"

@interface MessagesHandle ()

@property (nonatomic,assign) BOOL haveMore;


@end

@implementation MessagesHandle

- (id)init
{
    self = [super init];
    if (self) {
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSString *)path
{
    return MessagesPath;
}


+ (NSString *)commandName
{
    return @"getMessageList";
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    NSInteger pNo = [obj.p.pNo integerValue];
    if (pNo == 1) {//刷新数据
        [[UnreadMessage share] resetWithRefreshTime:obj.p.e];
        self.requestObj.p.e = obj.p.e;
        self.requestObj.p.t = [obj.p.t integerValue];
        [self.messages removeAllObjects];
    }
    
    NSArray *msgs = obj.d;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([msgs isKindOfClass:[NSArray class]]) {
        [msgs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull msg, NSUInteger idx, BOOL * _Nonnull stop) {
            MessageObject *msgObject = [[MessageObject alloc] initWithDictionary:msg];
            [tempArray addObject:msgObject];
        }];
    }
    [self.messages addObjectsFromArray:tempArray];
    self.resultList = [NSArray arrayWithArray:tempArray];
    
    NSInteger total = [obj.p.t integerValue];
    NSInteger count = self.requestObj.p.psize*(pNo-1) + self.messages.count;
    
    if (total > count) {
        self.haveMore = YES;
    }
}

- (void)didHandleFailure:(NSError *)error
{
    self.requestObj.p.pno = self.requestObj.p.pno-- > 1 ?:1;
}

- (void)buildRefreshMessage
{
    self.haveMore = NO;
    self.requestObj.p.t = 0;
    self.requestObj.p.s = @"";
    self.requestObj.p.pno = 1;
}

- (void)buildLoadMoreMessage
{
    self.requestObj.p.pno++;
}


@end

@implementation MessageObject

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        _messageId = dict[@"MID"];
        _messageContent = dict[@"MES"];
        _createTime = dict[@"CTM"];
    }
    return self;
}

+ (CGSize)calculateSizeWithContent:(NSString *)content maxWidth:(CGFloat)maxWidth font:(UIFont *)font
{
    return [content boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end


//
//  NetworkingManager.m
//  RedPacket
//
//  Created by itp on 15/10/26.
//  Copyright © 2015年 itp. All rights reserved.
//

#import "NetworkingManager.h"
#import "EMMNetworking.h"
#import "EMMSecurity.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define ServerKey       @"ITSM"

@interface NetworkingManager ()
{
    EMMBaseUrlManager   *_urlManager;
    EMMHTTPManager *_httpManager;
    EMMNetworkStatus *_networkStatus;
}
@end

@implementation NetworkingManager
@synthesize httpManager = _httpManager;
@synthesize urlManager = _urlManager;

+ (NetworkingManager *)share
{
    static NetworkingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithServiceKey:ServerKey];
    });
    return manager;
}

- (id)initWithServiceKey:(NSString *)serviceKey
{
    self = [super init];
    if (self) {
        _urlManager = [[EMMBaseUrlManager alloc] initWithServer:serviceKey];
        _httpManager = [[EMMHTTPManager alloc] initWithInternetBaseURL:[NSURL URLWithString:[_urlManager internetServerBaseUrl]]
                                                       intranetBaseUrl:[NSURL URLWithString:[_urlManager intranetServerBaseUrl]]];
        _networkStatus = [EMMNetworkStatus networkStatuWithHostname:[_urlManager intranetServerHost]];
    }
    return self;
}

@end

@implementation PageRequestObject
@synthesize s = _s;
@synthesize e = _e;
@synthesize t = _t;
@synthesize l = _l;
@synthesize pno = _pno;
@synthesize psize = _psize;

- (id)init
{
    self = [super init];
    if (self) {
        _t = 0;
        _pno = 1;
        _psize = 10;
    }
    return self;
}

- (NSDictionary *)networkingDictionary
{
    return @{@"STTM":self.s ?:@"",
             @"ENDTM":self.e ?:@"",
             @"TL":@(self.t),
             @"LSTTM":self.l ?:@"",
             @"PNO":@(self.pno),
             @"PSIZE":@(self.psize)};
}

@end

@implementation FunctionObject
@synthesize k = _k;
@synthesize v = _v;

- (NSDictionary *)networkingDictionary
{
    return @{@"K":self.k ?:NULLObject,
             @"V":self.v ?:NULLObject};
}


@end


@implementation RequestObject
@synthesize c = _c;
@synthesize t = _t;
@synthesize tt = _tt;
@synthesize l = _l;
@synthesize p = _p;
@synthesize d = _d;
@synthesize u = _u;
@synthesize eu = _eu;
@synthesize f = _f;

- (id)initWithCommandName:(NSString *)commandName
{
    self = [super init];
    if (self) {
        _c = commandName;
        _t = [EMMSecurity share].token ?:@"";
        _tt = @"0";
        _l = @"2052";
        _eu = [EMMSecurity share].userId ?:@"";
        _u = @"";//[NetworkingManager share].userInfo[@"accountId"] ? :@"";
        _p = [[PageRequestObject alloc] init];
        _d = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithCommandName:@""];
}

- (NSDictionary *)requestDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.c forKey:@"C"];
    [dict setObject:self.t ?:NULLObject forKey:@"T"];
    [dict setObject:self.tt forKey:@"TT"];
    [dict setObject:self.l forKey:@"L"];
    [dict setObject:self.u forKey:@"U"];
    [dict setObject:self.eu ?:NULLObject forKey:@"EU"];
    [dict setObject:self.p ? [self.p networkingDictionary]:[NSNull null] forKey:@"P"];

    if (self.d)
    {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.d options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dict setObject:dString forKey:@"D"];
    }
    else
    {
        [dict setObject:[NSNull null] forKey:@"D"];
    }
    
    [dict setObject:self.f ? [self.f networkingArray]:[NSNull null] forKey:@"F"];
    return dict;
}

- (NSString *)soapString
{
    NSDictionary *dict = [self requestDictionary];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end

@implementation PageResponseObject
@synthesize e = _e;
@synthesize t = _t;
@synthesize u = _u;
@synthesize l = _l;

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self)
    {
        _e = dict[@"ENDTM"];
        _t = dict[@"TL"];
        _u = dict[@"UPDTL"];
        _pNo = dict[@"PNO"];
        _l = dict[@"LRFT"];
        
    }
    return self;
}

@end

@implementation ResponseObject
@synthesize s = _s;
@synthesize m = _m;
@synthesize c = _c;
@synthesize d = _d;
@synthesize p = _p;

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self)
    {
        _s = [dict[@"S"] isEqualToString:@"T"];
        _m = dict[@"M"];
        _c = dict[@"C"];
        _d = dict[@"D"]?:NULLObject;
        NSDictionary *pDict = dict[@"P"];
        if ([pDict isKindOfClass:[NSDictionary class]])
        {
            _p = [[PageResponseObject alloc] initWithDictionary:pDict];
        }
    }
    return self;
}

@end



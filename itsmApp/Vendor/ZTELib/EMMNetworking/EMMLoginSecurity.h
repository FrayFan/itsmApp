//
//  EMMLoginSecurity.h
//  EMMNetworking
//
//  Created by itp on 2/25/16.
//  Copyright © 2016 zte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMMLoginSecurity : NSObject

+ (NSString*) makeLoginSecurity: (NSString *) userName withPassword:(NSString *)passWord;

@end

//
//  SimplePingClient.h
//  CheckPing
//
//  Created by Tran Anh Quoc on 7/24/15.
//  Copyright (c) 2015 Tran Anh Quoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

@interface SimplePingClient : NSObject <SimplePingDelegate> {
    
}

+ (void)pingHostname:(NSString*)hostName andResultCallback:(void(^)(NSString* latency))result;

@end

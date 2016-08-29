//
//  Constants.h
//  LateManagerment
//
//  Created by Tran Anh Quoc on 8/11/16.
//  Copyright © 2016 Tran Anh Quoc. All rights reserved.
//

#define _URL_FLAG 2
//Change server type ( 1: Production; 2: Staging; )

#if _URL_FLAG == 1

#define kURL_MESSAGELATE_URL        @"http://10.11.16.194:3000/api/v1/messages"
#define kURL_SERVER_URL             @"http://10.11.16.194:3000"
#define kURL_GOOGLE                 @"google.com"

#elif _URL_FLAG == 2

#define kURL_MESSAGELATE_URL        @"http://10.11.16.194:3000/api/v1/messages"
#define kURL_SERVER_URL             @"http://10.11.16.194:3000"
#define kURL_GOOGLE                 @"google.com"

#endif

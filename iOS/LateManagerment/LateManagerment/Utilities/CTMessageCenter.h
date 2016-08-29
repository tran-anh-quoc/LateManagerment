//
//  CTMessageCenter.h
//  LateManagerment
//
//  Created by Tran Anh Quoc on 8/9/16.
//  Copyright © 2016 Tran Anh Quoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTMessageCenter : NSObject
+ (id)sharedMessageCenter;

- (void)acknowledgeIncomingMessageWithId:(unsigned int)arg1;
- (void)acknowledgeOutgoingMessageWithId:(unsigned int)arg1;
- (void)addMessageOfType:(int)arg1 toArray:(id)arg2 withIdsFromArray:(id)arg3;
- (id)allIncomingMessages;
- (void)dealloc;
- (id)decodeMessage:(id)arg1;
- (id)deferredMessageWithId:(unsigned int)arg1;
- (id)encodeMessage:(id)arg1;
- (BOOL)getCharacterCount:(int*)arg1 andMessageSplitThreshold:(int*)arg2 forSmsText:(id)arg3;
- (int)incomingMessageCount;
- (id)incomingMessageWithId:(unsigned int)arg1 isDeferred:(BOOL)arg2;
- (id)incomingMessageWithId:(unsigned int)arg1;
- (id)init;
- (struct { int x1; int x2; })isDeliveryReportsEnabled:(BOOL*)arg1;
- (BOOL)isMmsConfigured;
- (BOOL)isMmsEnabled;
- (struct { int x1; int x2; })send:(id)arg1 withMoreToFollow:(BOOL)arg2;
- (struct { int x1; int x2; })send:(id)arg1;
- (struct { int x1; int x2; })sendMMS:(id)arg1;
- (struct { int x1; int x2; })sendMMSFromData:(id)arg1 messageId:(unsigned int)arg2;
- (void)sendMessageAsSmsToShortCodeRecipients:(id)arg1 andReplaceData:(id*)arg2;
- (struct { int x1; int x2; })sendSMS:(id)arg1 withMoreToFollow:(BOOL)arg2;
- (BOOL)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3 withID:(unsigned int)arg4;
- (BOOL)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3 withMoreToFollow:(BOOL)arg4 withID:(unsigned int)arg5;
- (BOOL)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3 withMoreToFollow:(BOOL)arg4;
- (BOOL)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3;
- (void)setDeliveryReportsEnabled:(BOOL)arg1;
- (id)statusOfOutgoingMessages;
@end

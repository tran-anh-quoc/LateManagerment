//
//  MainViewController.m
//  LateManagerment
//
//  Created by Tran Anh Quoc on 8/9/16.
//  Copyright © 2016 Tran Anh Quoc. All rights reserved.
//

#import "MainViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "CTMessageCenter.h"
#import "AFHTTPSessionManager.h"
#import "SimplePingClient.h"


extern CFStringRef const kCTMessageReceivedNotification;

CFNotificationCenterRef CTTelephonyCenterGetDefault();
void CTTelephonyCenterAddObserver(CFNotificationCenterRef ct, void* observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior sb);
void CTTelephonyCenterRemoveObserver(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object);
void *controllerObj;


@interface MainViewController () {
    NSInteger counter;
}

@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblPing;

@end

@implementation MainViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    controllerObj = (__bridge void *)(self);
    [self addTelephoneAndSMSObserver];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(doInBackground)
                                   userInfo:nil
                                    repeats:YES];
    [self makingBackgroundTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Background Functions

- (void)doInBackground {
    [SimplePingClient pingHostname:kURL_GOOGLE
                 andResultCallback:^(NSString *latency) {
                     NSString *result = latency ? latency : @"Fail";
                     counter++;
                     _lblPing.text = [NSString stringWithFormat:@"%@ms, %ld", result, (long)counter];
                 }];
}

- (void)makingBackgroundTask {
    __block UIBackgroundTaskIdentifier background_task;
    UIApplication *application =  [UIApplication sharedApplication];
    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
    }];
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Background time Remaining: %f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
            [NSThread sleepForTimeInterval:1];
        });
    }
}

#pragma mark - TelePhone Functions

- (void)addTelephoneAndSMSObserver{
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(),
                                 NULL,
                                 telephonyObserverCallback,
                                 kCTMessageReceivedNotification,
                                 NULL,
                                 CFNotificationSuspensionBehaviorHold);
}

// function C
void telephonyObserverCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if ([(__bridge NSString*)name isEqualToString:(__bridge NSString*)kCTMessageReceivedNotification]) {
        NSDictionary *info = (__bridge NSDictionary *)userInfo;
        CFNumberRef msgID = (CFNumberRef)CFBridgingRetain([info objectForKey:@"kCTMessageIdKey"]);
        int result;
        CFNumberGetValue((CFNumberRef)msgID, kCFNumberSInt32Type, &result);
        Class CTMessageCenter = NSClassFromString(@"CTMessageCenter");
        id mc = [CTMessageCenter sharedMessageCenter];
        id incMsg = [mc incomingMessageWithId:result];
        id phonenumber = [incMsg sender];
        NSString *senderNumber = (NSString *)[phonenumber performSelector:@selector(canonicalFormat)];
        id incMsgPart = [[incMsg items] objectAtIndex:0];
        NSData *smsData = [incMsgPart data];
        NSString *smsText = [[NSString alloc] initWithData:smsData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    senderNumber, @"phone_number",
                                    smsText, @"description", nil];
        
        [(__bridge MainViewController *)controllerObj performSelectorOnMainThread:@selector(handleData:)
                                                                   withObject:dictionary
                                                                waitUntilDone:NO];
    }
}

- (void)handleData:(NSDictionary *)dictionary {
    _lblPhoneNumber.text = [NSString stringWithFormat:@"Phone Number: %@", [dictionary objectForKey:@"phone_number"]];
    _lblMessage.text = [NSString stringWithFormat:@"Message: %@", [dictionary objectForKey:@"description"]];
    [self sendMessageToServer:dictionary];
}

#pragma mark - API Functions

- (void)sendMessageToServer:(NSDictionary *)dictionary {
    NSURL *URL = [NSURL URLWithString:kURL_MESSAGELATE_URL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:URL.absoluteString parameters:dictionary progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Send Success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error");
    }];
}

@end

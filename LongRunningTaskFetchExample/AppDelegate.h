//
//  AppDelegate.h
//  LongRunningTaskFetchExample
//
//  Created by Bob Dugan on 11/12/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) NSURLSession *session;
@property (strong, atomic) NSDate *startTime;

@end


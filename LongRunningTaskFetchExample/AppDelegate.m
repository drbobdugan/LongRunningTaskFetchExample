//
//  AppDelegate.m
//  LongRunningTaskFetchExample
//
//  Helped in part by this example: https://mobiforge.com/design-development/using-background-fetch-ios
//
//  Created by Bob Dugan on 11/12/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import "AppDelegate.h"
#import "BackgroundTimeRemainingUtility.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
   
        // Initialize session by constructing a NSURLSessionConfiguration
        NSURLSessionConfiguration *configuration =  [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"stonehill.edu.NSURLongRunningTaskFetchExample"];
        
        configuration.allowsCellularAccess = NO;
        configuration.timeoutIntervalForRequest = 300;
        configuration.timeoutIntervalForResource = 300;
        configuration.HTTPMaximumConnectionsPerHost = 1;
        configuration.sessionSendsLaunchEvents = YES;
        configuration.discretionary = YES;
        
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
// Delegate for UIApplicationDelegate
//
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
// Called when application moves from foreground to background and we are downloading a resource
  completionHandler:(void (^)()) completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


//
// Delegate for UIApplicationDelegate
//
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    _startTime = [NSDate date];
    NSLog(@"%s begin fetch", __PRETTY_FUNCTION__);
    [BackgroundTimeRemainingUtility NSLog];
    
    // Update UI
    ViewController *controller= (ViewController *) [[[UIApplication sharedApplication] keyWindow] rootViewController];

    dispatch_block_t work_to_do = ^{
        controller.status.text = @"Fetching...";
        controller.time.text = @"0";
        controller.data.text = @"";
    };
    
    if ([NSThread isMainThread])
    {
        work_to_do();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), work_to_do);
    }
    
    // Do the fetch
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:controller.URL.text]];
    [urlRequest setHTTPBody:nil];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:urlRequest];
    [dataTask resume];
    
    //
    //UIBackgroundFetchResultFailed
    //UIBackgroundFetchResultNoData
    //UIBackgroundFetchResultNewData
    //
    
    //Tell the system that you are done.
    completionHandler(UIBackgroundFetchResultNewData);
    [BackgroundTimeRemainingUtility NSLog];
    NSLog(@"%s end fetch", __PRETTY_FUNCTION__);
}

//
// Delegate of NSURLSessionDelegate
//
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                             NSURLCredential *credential))completionHandler
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
// Delegate of NSURLSessionDelegate
//
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
// Delegate of NSURLSessionDelegate
//
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"%s", __PRETTY_FUNCTION__);
 
    // If we are not in the "active" or foreground then log some background information to the console
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive)
    {
        [BackgroundTimeRemainingUtility NSLog];
    }
}

//
// Delegate of NSURLSessionDataDelegate
//
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    //Tells the delegate that the data task received the initial reply (headers) from the server.
    NSLog(@"%s: %@", __PRETTY_FUNCTION__,response);
    completionHandler(NSURLSessionResponseAllow);
}

//
// Delegate of NSURLSessionDataDelegate
//
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    // Called when task switches to a download task (not applicable for an upload example)
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
// Delegate of NSURLSessionDataDelegate
//
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    // Called when data task has received some data (not applicable for straight upload?)
    if (data != NULL)
    {
        NSLog(@"%s: %@", __PRETTY_FUNCTION__,[[NSString alloc]  initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding]);
    }
    else
    {
        NSLog(@"%s: but no actual data received.", __PRETTY_FUNCTION__);
    }
    
    // If we are not in the "active" or foreground then log some background information to the console
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive)
    {
        [BackgroundTimeRemainingUtility NSLog];
    }
}

//
// Delegate of NSURLSessionTaskDelegate
//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // Update UI
    ViewController *controller= (ViewController *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
    NSDate *stopTime = [NSDate date];
    NSTimeInterval executionTime = [stopTime timeIntervalSinceDate:controller.startTime];
    NSString *status;
    NSString *time =  [NSString stringWithFormat:@"%.1f",executionTime];
    NSString *data;
   
    
    if (error) {
        NSLog(@"%s %@ failed: %@", __PRETTY_FUNCTION__, task.originalRequest.URL, error);
        status = @"Failed";
        data =[NSString stringWithFormat: @"%@", error];
    }
    else
    {
        NSLog(@"%s succeeded with response: %@",  __PRETTY_FUNCTION__, task.response);
        status = @"Ready";
        data = [NSString stringWithFormat: @"%@", task.response];
    }
    
    dispatch_block_t work_to_do = ^{
        controller.status.text = status;
        controller.time.text = time;
        controller.data.text = data;
    };
    
    if ([NSThread isMainThread])
    {
        work_to_do();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), work_to_do);
    }

    
    // If we are not in the "active" or foreground then log some background information to the console
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive)
    {
        [BackgroundTimeRemainingUtility NSLog];
    }
}

//
// Delegate of NSURLSessionTaskDelegate (NOT CALLED IN THIS EXAMPLE)
//
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                             NSURLCredential *credential))completionHandler
{
    
    // Requests credentials from the delegate in response to an authentication request from the remote server.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
// Delegate of NSURLSessionTaskDelegate (NOT CALLED IN THIS EXAMPLE)
//
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    // Called when data task has the option to cache some data (not applicable to straight upload?)
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
// Delegate of NSURLSessionTaskDelegate
//
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    // Periodically informs the delegate of the progress of sending body content to the server.
    
    // Compute progress percentage
    float progress = (float)totalBytesSent / (float)totalBytesExpectedToSend;
    
    // Compute time executed so far
    ViewController *controller= (ViewController *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
    NSDate *stopTime = [NSDate date];
    NSTimeInterval executionTime = [stopTime timeIntervalSinceDate:self.startTime];
    
    // Send info to console
    NSLog(@"%s bytesSent = %lld, totalBytesSent: %lld, totalBytesExpectedToSend: %lld, progress %.3f, time (s): %.1f", __PRETTY_FUNCTION__, bytesSent, totalBytesSent, totalBytesExpectedToSend, progress*100, executionTime);
    
    // Update UI
    dispatch_block_t work_to_do = ^{
          controller.time.text = [NSString stringWithFormat:@"%.1f",executionTime];
    };
    
    if ([NSThread isMainThread])
    {
        work_to_do();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), work_to_do);
    }
    
    // If we are not in the "active" or foreground then log some background information to the console
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive)
    {
        [BackgroundTimeRemainingUtility NSLog];
    }
}

//
// Delegate of NSURLSessionTaskDelegate  (NOT CALLED IN THIS EXAMPLE)
//
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    //
    //This delegate method is called under two circumstances:
    //- To provide the initial request body stream if the task was created with uploadTaskWithStreamedRequest:
    //- To provide a replacement request body stream if the task needs to resend a request that has a body stream because of an authentication challenge or other recoverable serve error.
    //
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


//
// Delegate of NSURLSessionTaskDelegate  (NOT CALLED IN THIS EXAMPLE)
//
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    // This method is called only for tasks in default and ephemeral sessions. Tasks in background sessions automatically follow redirects.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
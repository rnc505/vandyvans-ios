//
//  VVAppDelegate.m
//  Vandy Vans
//
//  Created by Seth Friedman on 10/11/12.
//  Copyright (c) 2012 VandyApps. All rights reserved.
//

#import "VVAppDelegate.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "VVArrivalTimeTableViewController.h"
#import "VVAlertBuilder.h"
#import "VVAppearanceBuilder.h"
#import "VVRoute.h"

static NSTimeInterval const kStaleTimeInterval = -14*24*60*60; // 2 weeks ago

@implementation VVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [VVAppearanceBuilder buildAppearance];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *vanArrivingAlertView = [VVAlertBuilder vanArrivingAlertWithRouteName:notification.userInfo[@"RouteName"] andStopName:notification.userInfo[@"StopName"]];
        [vanArrivingAlertView show];
    } else {
        application.applicationIconBadgeNumber += notification.applicationIconBadgeNumber;
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Ensures that the badge number is cleaned up when no notifications are present.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Background Fetch

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[userDefaults objectForKey:kAnnotationsDateKey] timeIntervalSinceNow] <= kStaleTimeInterval) {
        [self updateAnnotationsWithUserDefaults:userDefaults
                              completionHandler:completionHandler];
    } else if ([[userDefaults objectForKey:kPolylineDateKey] timeIntervalSinceNow] <= kStaleTimeInterval) {
        [self updatePolylineWithUserDefaults:userDefaults
                           completionHandler:completionHandler];
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

#pragma mark - Helper Methods

- (void)updateAnnotationsWithUserDefaults:(NSUserDefaults *)userDefaults completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [VVRoute annotationsForRoute:[VVRoute routeWithRouteID:@"745"]
             withCompletionBlock:^(NSArray *stops) {
                 [userDefaults setObject:[NSDate date]
                                  forKey:kAnnotationsDateKey];
                 
                 dispatch_group_leave(group);
             }];
    
    dispatch_group_enter(group);
    [VVRoute annotationsForRoute:[VVRoute routeWithRouteID:@"746"]
             withCompletionBlock:^(NSArray *stops) {
                 dispatch_group_leave(group);
             }];
    
    dispatch_group_enter(group);
    [VVRoute annotationsForRoute:[VVRoute routeWithRouteID:@"749"]
             withCompletionBlock:^(NSArray *stops) {
                 dispatch_group_leave(group);
             }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [userDefaults synchronize];
        
        completionHandler(UIBackgroundFetchResultNewData);
    });
}

- (void)updatePolylineWithUserDefaults:(NSUserDefaults *)userDefaults completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [VVRoute polylineForRoute:[VVRoute routeWithRouteID:@"745"]
          withCompletionBlock:^(MKPolyline *polyline) {
              [userDefaults setObject:[NSDate date]
                               forKey:kPolylineDateKey];
              
              dispatch_group_leave(group);
          }];
    
    dispatch_group_enter(group);
    [VVRoute polylineForRoute:[VVRoute routeWithRouteID:@"746"]
          withCompletionBlock:^(MKPolyline *polyline) {
              dispatch_group_leave(group);
          }];
    
    dispatch_group_enter(group);
    [VVRoute polylineForRoute:[VVRoute routeWithRouteID:@"749"]
          withCompletionBlock:^(MKPolyline *polyline) {
              dispatch_group_leave(group);
          }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [userDefaults synchronize];
        
        completionHandler(UIBackgroundFetchResultNewData);
    });
}

@end

//
//  AppDelegate.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "NAViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "Helper.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (@available(iOS 13.0, *)) {
        window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval: UIApplicationBackgroundFetchIntervalMinimum];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    
    if ([Helper valueFromUserDefaults:@"updateFrequency"] == 0) {
        [Helper saveToUserDefaults:5 forKey:@"updateFrequency"];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [self sendNotification:@"Hi its news.am"];
//    NSArray *viewControllers = ((UINavigationController *)self.window.rootViewController.childViewControllers[0]).viewControllers;
//    if (viewControllers.count > 0) {
//        for (id vc in viewControllers) {
//            if ([vc isKindOfClass:[NAViewController class]]) {
//                NAViewController *naVC = (NAViewController *)vc;
//            }
//        }
//    }
}

- (void)sendNotification:(NSString *)body {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"News.am";
    content.body = body;
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2.0 repeats:false];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ContentIdentifier" content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[CoreDataManager defaultManager] saveContext];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
}


@end

//
//  Helper.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 5/24/20.
//  Copyright © 2020 Smbat Tumasyan. All rights reserved.
//

#import "Helper.h"
#import <AFNetworking.h>

@implementation Helper

+ (NSString *) createFilePath:(NSString *)aString{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@.pdf", aString]];
}

+ (BOOL)connectedToInternet
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    BOOL i = [[AFNetworkReachabilityManager sharedManager] isReachable];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    return i;
}

+(void)saveToUserDefaults:(NSInteger)integer forKey:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    if (standardUserDefaults) {
        [standardUserDefaults setInteger:integer forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (NSInteger)valueFromUserDefaults:(NSString *)key {
    NSInteger savedValue = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    return savedValue;
}


@end

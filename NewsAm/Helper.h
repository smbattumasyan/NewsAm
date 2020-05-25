//
//  Helper.h
//  NewsAm
//
//  Created by Smbat Tumasyan on 5/24/20.
//  Copyright © 2020 Smbat Tumasyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject

+ (NSString *) createFilePath:(NSString *)aString;
+ (BOOL)connectedToInternet;
+ (void)saveToUserDefaults:(NSInteger)integer forKey:(NSString *)key;
+ (NSInteger)valueFromUserDefaults:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

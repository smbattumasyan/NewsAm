//
//  Helper.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 5/24/20.
//  Copyright © 2020 Smbat Tumasyan. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString *) createFilePath:(NSString *)aString{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *strID = @"abc";//[aString substringWithRange:NSMakeRange(aString.length-11, 6)];
    return [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@.pdf", strID]];
}


@end

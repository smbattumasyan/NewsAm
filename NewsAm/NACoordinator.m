//
//  NACoordinator.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/16/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NACoordinator.h"

@implementation NACoordinator

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.businessLogic = [BusinessLogic sharedInstance];
    }
    return self;
}

- (BOOL)saveNewsDataToDatabase:(NSArray *)newsDatas {
    return [self.businessLogic saveNews:newsDatas];
}

@end

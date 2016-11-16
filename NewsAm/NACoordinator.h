//
//  NACoordinator.h
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/16/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"

@interface NACoordinator : NSObject

#pragma Mark - Propertyes
@property (strong, nonatomic) BusinessLogic* businessLogic;

#pragma Mark - Class Methods
- (void)saveNewsDataToDatabase:(NSArray *)newsDatas;

@end

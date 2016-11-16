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

@property (strong, nonatomic) BusinessLogic* businessLogic;

- (void)saveNewsDataToDatabase:(NSArray *)newsDatas;

@end

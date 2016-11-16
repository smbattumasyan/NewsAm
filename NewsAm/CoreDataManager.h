//
//  CoreDataManager.h
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

#pragma Mark - Propertyes
@property (readonly, strong) NSPersistentContainer *persistentContainer;

#pragma Mark - Class Methods
+ (instancetype)defaultManager;
- (void)saveContext;

@end

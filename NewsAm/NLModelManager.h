//
//  NLModelManager.h
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "NewsList+CoreDataProperties.h"

@interface NLModelManager : NSObject

@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+ (instancetype)defaultManager;
- (void)addNews:(NSArray *)news;
//- (void)deleteMessage:(NewsList *)message;

@end

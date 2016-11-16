//
//  NLModelManager.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NLModelManager.h"

@implementation NLModelManager

+ (instancetype)defaultManager {
    static NLModelManager *defaultManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.coreDataManager = [CoreDataManager defaultManager];
    }
    return self;
}

- (void)addNews:(NSArray *)news {

    for (NSDictionary *dict in news) {
        NewsList *newsList = [NSEntityDescription insertNewObjectForEntityForName:@"NewsList" inManagedObjectContext:self.coreDataManager.persistentContainer.viewContext];
        newsList.name = dict[@"newsTitle"];
        newsList.newsDescription = dict[@"newsDescription"];
        newsList.imgUrl = dict[@"imgURL"];
        newsList.date = dict[@"date"];
        newsList.link = dict[@"link"];
    }

    [self.coreDataManager saveContext];
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *request          = [NewsList fetchRequest];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    _fetchedResultsController        = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                           managedObjectContext:self.coreDataManager.persistentContainer.viewContext
                                                                             sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Error Description: %@",[error userInfo]);
    }

    return _fetchedResultsController;
}



@end

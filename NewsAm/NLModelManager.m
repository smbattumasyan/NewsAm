//
//  NLModelManager.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NLModelManager.h"

@implementation NLModelManager

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

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
        newsList.newsID = dict[@"newsID"];
    }

    [self.coreDataManager saveContext];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedSavedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *request          = [NewsList fetchRequest];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
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

- (NSFetchedResultsController *)fetchedSavedResultsController
{
    if (_fetchedSavedResultsController != nil) {
        return _fetchedSavedResultsController;
    }

    NSFetchRequest *request          = [NewsList fetchRequest];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"saved == YES"];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[sortDescriptor]];
    _fetchedSavedResultsController        = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                           managedObjectContext:self.coreDataManager.persistentContainer.viewContext
                                                                             sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    if (![_fetchedSavedResultsController performFetch:&error]) {
        NSLog(@"Error Description: %@",[error userInfo]);
    }

    return _fetchedSavedResultsController;
}

@end


//    [NSFetchedResultsController deleteCacheWithName:nil];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"saved == YES"];
//    [self.modelManager.fetchedResultsController.fetchRequest setPredicate:predicate];
//
//    NSError *error = nil;
//    if (![self.modelManager.fetchedResultsController performFetch:&error]) {
//        NSLog(@"%@, %@", error, [error userInfo]);
//        abort();
//    }

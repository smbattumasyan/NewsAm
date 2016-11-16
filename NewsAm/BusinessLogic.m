//
//  BusinessLogic.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "BusinessLogic.h"


@implementation BusinessLogic

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

+ (instancetype)sharedInstance {
    static BusinessLogic *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nlModelManager = [NLModelManager defaultManager];
    }
    return self;
}

- (void)saveNews:(NSArray *)newsList {

    NSMutableArray<NSDictionary *> *newNewsList = [[NSMutableArray alloc] initWithArray:newsList];
    NSArray<NewsList *> *savedNews = self.nlModelManager.fetchedResultsController.fetchedObjects;

    for (NSInteger i = newsList.count-1 ; i >= 0; i--) {
        for (NSInteger j = 0; j < savedNews.count; j++) {
            if ([[newNewsList[i] objectForKey:@"date"] isEqualToDate:savedNews[j].date]) {
                [newNewsList removeObject:newNewsList[i]];
                break;
            }
        }
    }
    [self.nlModelManager addNews:newNewsList];
}

@end

//
//  NewsList+CoreDataProperties.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "NewsList+CoreDataProperties.h"

@implementation NewsList (CoreDataProperties)

+ (NSFetchRequest<NewsList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NewsList"];
}

@dynamic name;
@dynamic newsDescription;
@dynamic date;
@dynamic link;
@dynamic imgUrl;

@end

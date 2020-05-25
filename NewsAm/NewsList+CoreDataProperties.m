//
//  NewsList+CoreDataProperties.m
//  
//
//  Created by Smbat Tumasyan on 5/25/20.
//
//

#import "NewsList+CoreDataProperties.h"

@implementation NewsList (CoreDataProperties)

+ (NSFetchRequest<NewsList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"NewsList"];
}

@dynamic date;
@dynamic imgUrl;
@dynamic link;
@dynamic name;
@dynamic newsDescription;
@dynamic newItem;
@dynamic saved;
@dynamic newsID;

@end

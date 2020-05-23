//
//  NewsList+CoreDataProperties.m
//  
//
//  Created by Smbat Tumasyan on 5/23/20.
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
@dynamic new;
@dynamic saved;

@end

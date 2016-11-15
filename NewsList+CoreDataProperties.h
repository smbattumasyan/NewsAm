//
//  NewsList+CoreDataProperties.h
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "NewsList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NewsList (CoreDataProperties)

+ (NSFetchRequest<NewsList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *newsDescription;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *imgUrl;

@end

NS_ASSUME_NONNULL_END

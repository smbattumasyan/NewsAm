//
//  NewsList+CoreDataProperties.h
//  
//
//  Created by Smbat Tumasyan on 5/25/20.
//
//

#import "NewsList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NewsList (CoreDataProperties)

+ (NSFetchRequest<NewsList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *imgUrl;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *newsDescription;
@property (nonatomic) BOOL newItem;
@property (nonatomic) BOOL saved;
@property (nullable, nonatomic, copy) NSString *newsID;

@end

NS_ASSUME_NONNULL_END

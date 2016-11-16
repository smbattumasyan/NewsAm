//
//  NATableViewCell.h
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsList+CoreDataProperties.h"

@interface NATableViewCell : UITableViewCell

@property (strong, nonatomic) NewsList *aNews;

@end

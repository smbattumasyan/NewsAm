//
//  NADetailsViewController.h
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/16/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLModelManager.h"

@interface NADetailsViewController : UIViewController

#pragma Mark - Methods
+ (NADetailsViewController *)create;

#pragma Mark - Propertyes
@property(strong, nonatomic)NewsList *newsList;
@property (strong, nonatomic) __block NLModelManager *modelManager;

@end

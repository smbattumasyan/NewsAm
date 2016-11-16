//
//  NAViewController.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NAViewController.h"
#import "TFHpple.h"
#import "NATableViewCell.h"
#import "NLModelManager.h"
#import "NACoordinator.h"

@interface NAViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *newsData;

@property (strong, nonatomic) NACoordinator *naCoordinator;

@property (strong, nonatomic) NLModelManager *modelManager;


@end

@implementation NAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.naCoordinator = [[NACoordinator alloc] init];

    [self loadNewsData];

    self.modelManager = [NLModelManager defaultManager];

//    NSLog(@"corDataaa :%@", self.modelManager.fetchedResultsController.fetchedObjects);


//    [self loadNewsLinks];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------------------------------------------
#pragma mark - TableView DataSource Delegate
//-------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelManager.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NATableViewIdentifier";

    NATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if(cell == nil) {

        cell = [[NATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    NewsList *newsList = [self.modelManager.fetchedResultsController objectAtIndexPath:indexPath];

    cell.aNews = newsList;
    return cell;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

//- (void)loadNewsLinks {
//
//    NSURL *url = [NSURL URLWithString:@"https://news.am/eng/news/allregions/allthemes/2016/11/15/"];
//    NSString *xPath = @"//div[@class='articles-list casual']/article/div[@class='describe']/div[@class='title']/a";
//    NSArray *elements = [self getHTMLElementsFrom:url xPath:xPath];
//
////    NSLog(@"elements: %@", elements);
//    /*
//     //div[@class='dl']/table/tr/td[@class='r']"
//     */
//    self.armNews = [[NSMutableArray alloc] init];
//    self.medNews = [[NSMutableArray alloc] init];
//    self.sportNews = [[NSMutableArray alloc] init];
//    self.styleNews = [[NSMutableArray alloc] init];
//    self.newsName = [[NSMutableArray alloc] init];
//
//    for (TFHppleElement *element in elements) {
//        //        NSLog(@"element: %@", [element objectForKey:@"href"]);
//
//        NSLog(@"elements: %@", element.content);
//        [self.newsName addObject:element.content];
//        if ([[[element objectForKey:@"href"] substringToIndex:3] isEqualToString:@"arm"]) {
//            [self.armNews addObject:[@"https://news.am/" stringByAppendingString:[element objectForKey:@"href"]]];
//        } else if ([[[element objectForKey:@"href"] substringToIndex:4] isEqualToString:@"//me"]) {
//            [self.armNews addObject:[@"https:" stringByAppendingString:[element objectForKey:@"href"]]];
//        } else if ([[[element objectForKey:@"href"] substringToIndex:4] isEqualToString:@"//sp"]) {
//            [self.armNews addObject:[@"https:" stringByAppendingString:[element objectForKey:@"href"]]];
//        } else if ([[[element objectForKey:@"href"] substringToIndex:4] isEqualToString:@"//st"]) {
//            [self.armNews addObject:[@"https:" stringByAppendingString:[element objectForKey:@"href"]]];
//        }
//
//        //        [linkList addObject:[element objectForKey:@"href"]];
//    }
//
//    NSLog(@"linkLikst: %@ ", self.armNews);
//}
// /div[@class='describe']/div[@class='title']/a
- (void)loadNewsData {

        NSURL *url = [NSURL URLWithString:@"https://news.am/arm/news/allregions/allthemes/2016/11/15/"];
        NSString *xPath = @"//div[@class='articles-list casual']/article";
        NSArray *articles = [self getHTMLElementsFrom:url xPath:xPath];
    self.newsData = [[NSMutableArray alloc] init];

    for (TFHppleElement *article in articles) {

        TFHppleElement *newsTitle = [[article searchWithXPathQuery:@"//div[@class='describe']/div[@class='title']/a"] firstObject];

//        NSLog(@"elementtt: %@", newsTitle.content);

        TFHppleElement *newsDescription = [[article searchWithXPathQuery:@"//div[@class='describe']/div[@class='text']"] firstObject];
//            NSLog(@"newsdescrioption: %@", newsDescription.content);

        TFHppleElement *imgURl = [[article searchWithXPathQuery:@"//a/img"] firstObject];
        NSString *imageURL = [imgURl objectForKey:@"src"];
        NSLog(@"photoLink: %@", imageURL);

        if (![[imageURL substringToIndex:4] isEqualToString:@"http"]) {
            imageURL = [@"https://news.am" stringByAppendingString:[imgURl objectForKey:@"src"]];
        }
        NSLog(@"photoLink: %@", imageURL);
        TFHppleElement *dateTime = [[article searchWithXPathQuery:@"//div[@class='describe']/div[@class='date']/time"] firstObject];
//        NSLog(@"element: %@",[self dateFromString:dateTime.content]);



        [self.newsData addObject:@{@"newsTitle" : newsTitle.content,
                                   @"newsDescription" : newsDescription.content,
                                   @"imgURL" : imageURL,
                                   @"date" : [self dateFromString:dateTime.content]}];

    }

    [self.naCoordinator saveNewsDataToDatabase:self.newsData];
}

- (NSDate *)dateFromString:(NSString *)stringDate {
//yyyy-MM-ddZHH:mm:ss
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"HH:mm, dd.MM.yyyy"];
    return [dateFormatter dateFromString:stringDate];
}

- (NSArray *)getHTMLElementsFrom:(NSURL *)url xPath:(NSString *)xPath {

    NSData *data = [NSData dataWithContentsOfURL:url];
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    return [doc searchWithXPathQuery:xPath];
}


@end

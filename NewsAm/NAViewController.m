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

@interface NAViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *armNews;
@property (strong, nonatomic) NSMutableArray *medNews;
@property (strong, nonatomic) NSMutableArray *sportNews;
@property (strong, nonatomic) NSMutableArray *styleNews;
@property (strong, nonatomic) NSMutableArray *newsName;


@end

@implementation NAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NLModelManager *modelManager = [NLModelManager defaultManager];

    [modelManager addNews:nil];

    NSLog(@"corDataaa :%@", modelManager.fetchedResultsController.fetchedObjects);


    [self loadNewsLinks];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------------------------------------------
#pragma mark - TableView DataSource Delegate
//-------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.armNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NATableViewIdentifier";

    NATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if(cell == nil) {

        cell = [[NATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.textLabel.text = self.armNews[indexPath.row];
    return cell;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)loadNewsLinks {

    NSURL *url = [NSURL URLWithString:@"https://news.am/eng/news/allregions/allthemes/2016/11/15/"];
    NSString *xPath = @"//div[@class='articles-list casual']/article/div[@class='describe']/div[@class='title']/a";
    NSArray *elements = [self getHTMLElementsFrom:url xPath:xPath];

//    NSLog(@"elements: %@", elements);
    /*
     //div[@class='dl']/table/tr/td[@class='r']"
     */
    self.armNews = [[NSMutableArray alloc] init];
    self.medNews = [[NSMutableArray alloc] init];
    self.sportNews = [[NSMutableArray alloc] init];
    self.styleNews = [[NSMutableArray alloc] init];
    self.newsName = [[NSMutableArray alloc] init];

    for (TFHppleElement *element in elements) {
        //        NSLog(@"element: %@", [element objectForKey:@"href"]);

        NSLog(@"elements: %@", element.content);
        [self.newsName addObject:element.content];
        if ([[[element objectForKey:@"href"] substringToIndex:3] isEqualToString:@"arm"]) {
            [self.armNews addObject:[@"https://news.am/" stringByAppendingString:[element objectForKey:@"href"]]];
        } else if ([[[element objectForKey:@"href"] substringToIndex:4] isEqualToString:@"//me"]) {
            [self.armNews addObject:[@"https:" stringByAppendingString:[element objectForKey:@"href"]]];
        } else if ([[[element objectForKey:@"href"] substringToIndex:4] isEqualToString:@"//sp"]) {
            [self.armNews addObject:[@"https:" stringByAppendingString:[element objectForKey:@"href"]]];
        } else if ([[[element objectForKey:@"href"] substringToIndex:4] isEqualToString:@"//st"]) {
            [self.armNews addObject:[@"https:" stringByAppendingString:[element objectForKey:@"href"]]];
        }

        //        [linkList addObject:[element objectForKey:@"href"]];
    }

    NSLog(@"linkLikst: %@ ", self.armNews);
}

- (void)loadNewsData {



//
//    NSURL *url = [NSURL URLWithString:self.armNews[0]];
//    NSString *xPath = @"//div[@class='news-list short']/a";
//    NSArray *elements = [self getHTMLElementsFrom:url xPath:xPath];


}

- (NSArray *)getHTMLElementsFrom:(NSURL *)url xPath:(NSString *)xPath {

    NSData *data = [NSData dataWithContentsOfURL:url];
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    return [doc searchWithXPathQuery:xPath];
}


@end

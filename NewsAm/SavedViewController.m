//
//  SavedViewController.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 5/23/20.
//  Copyright © 2020 Smbat Tumasyan. All rights reserved.
//

#import "SavedViewController.h"
#import "TFHpple.h"
#import "NATableViewCell.h"
#import "NLModelManager.h"
#import "NACoordinator.h"
#import "NADetailsViewController.h"

@interface SavedViewController ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

//------------------------------------------------------------------------------------------
#pragma mark - Properties
//------------------------------------------------------------------------------------------
@property (strong, nonatomic) NSMutableArray *newsData;
@property (strong, nonatomic) NACoordinator  *naCoordinator;
@property (strong, nonatomic) NLModelManager *modelManager;
@property (strong, nonatomic) UIRefreshControl * refreshControl;

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SavedViewController

//-------------------------------------------------------------------------------------------
#pragma mark - Life Cyrcle
//-------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self updateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:@"Saved"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------------------------------------------
#pragma mark - TableView DataSource Delegate
//-------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelManager.fetchedSavedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"NATableViewIdentifier";
    NATableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[NATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NewsList *newsList = [self.modelManager.fetchedSavedResultsController objectAtIndexPath:indexPath];
    cell.aNews         = newsList;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NADetailsViewController *naDetailsVC = [NADetailsViewController create];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NewsList *newsList = [self.modelManager.fetchedSavedResultsController objectAtIndexPath:selectedIndexPath];
    newsList.new = false;
    naDetailsVC.link = newsList.link;
    [self.modelManager.coreDataManager saveContext];
    [self.navigationController pushViewController:naDetailsVC animated:true];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)setupTableView {
    self.modelManager  = [NLModelManager defaultManager];
    self.naCoordinator = [[NACoordinator alloc] init];
    self.modelManager.fetchedSavedResultsController.delegate = self;
}

- (void)updateData {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)handleRefresh:(NSString *)str {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSString *)newsLink:(TFHppleElement *)link {

    NSString *armNews = nil;
        if ([[[link objectForKey:@"href"] substringToIndex:3] isEqualToString:@"arm"]) {
             armNews = [@"https://news.am/" stringByAppendingString:[link objectForKey:@"href"]];
        } else if ([[[link objectForKey:@"href"] substringToIndex:2] isEqualToString:@"//"]) {
            armNews  = [@"https:" stringByAppendingString:[link objectForKey:@"href"]];
        }

    return armNews;
}

- (void)loadNewsData {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://news.am/arm/news/allregions/allthemes/%@",[self stringFromDate:[NSDate date]]]];
        NSString *xPath   = @"//div[@class='articles-list casual']/article";
        NSArray *articles = [self getHTMLElementsFrom:url xPath:xPath];
    self.newsData = [[NSMutableArray alloc] init];

    for (TFHppleElement *article in articles) {

        TFHppleElement *newsTitle = [[article searchWithXPathQuery:@"//div[@class='describe']/div[@class='title']/a"] firstObject];
        TFHppleElement *newsDescription = [[article searchWithXPathQuery:@"//div[@class='describe']/div[@class='text']"] firstObject];
        TFHppleElement *imgURl = [[article searchWithXPathQuery:@"//a/img"] firstObject];
        NSString *imageURL     = [imgURl objectForKey:@"src"];
        if (![[imageURL substringToIndex:4] isEqualToString:@"http"]) {
            imageURL = [@"https://news.am" stringByAppendingString:[imgURl objectForKey:@"src"]];
        }
        TFHppleElement *dateTime = [[article searchWithXPathQuery:@"//div[@class='describe']/div[@class='date']/time"] firstObject];
        TFHppleElement *link = [[article searchWithXPathQuery:@"//div[@class='describe']/div[@class='title']/a"] firstObject];
        [self.newsData addObject:@{@"newsTitle" : newsTitle.content,
                                   @"newsDescription" : newsDescription.content,
                                   @"imgURL" : imageURL,
                                   @"date" : [self dateFromString:dateTime.content],
                                   @"link" : [self newsLink:link]}];

    }

    [self.naCoordinator saveNewsDataToDatabase:self.newsData];
}

- (NSDate *)dateFromString:(NSString *)stringDate {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm, dd.MM.yyyy"];
    return [dateFormatter dateFromString:stringDate];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];

    return [formatter stringFromDate:date];
}

- (NSArray *)getHTMLElementsFrom:(NSURL *)url xPath:(NSString *)xPath {

    NSData *data = [NSData dataWithContentsOfURL:url];
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    return [doc searchWithXPathQuery:xPath];
}

//-------------------------------------------------------------------------------------------
#pragma mark - NSFetchedResultsControllerDelegate
//-------------------------------------------------------------------------------------------

- (void)controllerWillChangeContent: (NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths: @[newIndexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths: @[newIndexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

//------------------------------------------------------------------------------------------
#pragma mark - Navigation
//------------------------------------------------------------------------------------------

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NADetailsViewController"]) {
        NADetailsViewController *naDetailsVC = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NewsList *newsList = [self.modelManager.fetchedSavedResultsController objectAtIndexPath:selectedIndexPath];
        naDetailsVC.link   = newsList.link;
    }
}


@end



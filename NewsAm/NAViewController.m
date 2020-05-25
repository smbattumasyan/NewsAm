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
#import "NADetailsViewController.h"
#import "BNHtmlPdfKit.h"
#import "Helper.h"
#import "AppDelegate.h"

@interface NAViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIScrollViewDelegate, BNHtmlPdfKitDelegate>

//------------------------------------------------------------------------------------------
#pragma mark - Properties
//------------------------------------------------------------------------------------------
@property (strong, nonatomic) NSMutableArray *newsData;
@property (strong, nonatomic) NACoordinator  *naCoordinator;
@property (strong, nonatomic) __block NLModelManager *modelManager;
@property (strong, nonatomic) UIRefreshControl * refreshControl;
@property (strong, nonatomic) BNHtmlPdfKit *htmlPdfKit;
@property (strong, nonatomic) UIView *animationView;
@property (strong, nonatomic) NSTimer *timer;

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NAViewController

//-------------------------------------------------------------------------------------------
#pragma mark - Life Cyrcle
//-------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self updateData];
    [self loadNewsData];
    
    [self updateByTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateByTimer) name:@"updateByTimer" object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:@"News Feed"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
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
    NATableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[NATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NewsList *newsList = [self.modelManager.fetchedResultsController objectAtIndexPath:indexPath];
    cell.aNews         = newsList;
    cell.save = ^{
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [self startAnimating];
        if (newsList.saved) {
            NSString *filePath = [Helper createFilePath: newsList.newsID];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                [self.navigationItem.rightBarButtonItem setTitle:@"Save"];
               [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                newsList.saved = NO;
                [self.navigationController.navigationBar setUserInteractionEnabled:YES];
                [self.modelManager.coreDataManager saveContext];
                [self.tableView reloadData];
            }
            [self stopAnimating];
            return;
        }
        newsList.saved = YES;
        [self createPdf:newsList.link :newsList.newsID];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NADetailsViewController *naDetailsVC = [NADetailsViewController create];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NewsList *newsList = [self.modelManager.fetchedResultsController objectAtIndexPath:selectedIndexPath];
    newsList.newItem = false;
    naDetailsVC.newsList   = newsList;
    naDetailsVC.modelManager = self.modelManager;
    [self.modelManager.coreDataManager saveContext];
    [self.navigationController pushViewController:naDetailsVC animated:true];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

- (void)setupTableView {
    self.modelManager  = [NLModelManager defaultManager];
    self.naCoordinator = [[NACoordinator alloc] init];
    self.modelManager.fetchedResultsController.delegate = self;
    if (@available(iOS 13.0, *)) {
        self.tableView.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

- (void)updateByTimer {
    NSInteger interval = [Helper valueFromUserDefaults:@"updateFrequency"];
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats: YES block:^(NSTimer * _Nonnull timer) {
        if ([self loadNewsData]) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate sendNotification:@"Let's check news."];
            [self.tableView reloadData];
            [self updateByTimer];
        }
    }];
}

- (void)updateData {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)handleRefresh:(NSString *)str {
    [self loadNewsData];
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

- (BOOL)loadNewsData {

    NSLog(@"=========== Update Datas ===========");
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
                                   @"link" : [self newsLink:link],
                                   @"newsID" : [self randomStringWithLength:10],
        }];
    }
    
    return [self.naCoordinator saveNewsDataToDatabase:self.newsData];
}



- (NSString *)randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];

    for (int i=0; i<len; i++) {
         [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    return randomString;
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

- (void) createPdf:(NSString *)link :(NSString *)newsID {
    _htmlPdfKit = [[BNHtmlPdfKit alloc] init];
    _htmlPdfKit.delegate = self;
    _htmlPdfKit.pageSize = BNPageSizeCustom;
    _htmlPdfKit.customPageSize = CGSizeMake(375, 1500);
    [_htmlPdfKit saveUrlAsPdf:[NSURL URLWithString:link] toFile: [Helper createFilePath: newsID]];
}

- (void)startAnimating {
    [self.animationView removeFromSuperview];
    self.animationView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview: self.animationView];
    self.animationView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    UIActivityIndicatorView *snipper = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.animationView addSubview:snipper];
    snipper.translatesAutoresizingMaskIntoConstraints = NO;
    [[snipper.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[snipper.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    
    
    [snipper startAnimating];
}

- (void)stopAnimating {
    [self.animationView removeFromSuperview];
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

//-------------------------------------------------------------------------------------------
#pragma mark - BNHtmlPdfKitDelegate
//-------------------------------------------------------------------------------------------

- (void)htmlPdfKit:(BNHtmlPdfKit *)htmlPdfKit didSavePdfFile:(NSString *)file {
    [self.modelManager.coreDataManager saveContext];
    [self stopAnimating];
    [self.tableView reloadData];
}


@end

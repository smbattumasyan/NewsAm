//
//  NADetailsViewController.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/16/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NADetailsViewController.h"
#import "Helper.h"
#import "BNHtmlPdfKit.h"

@interface NADetailsViewController () <UIWebViewDelegate, BNHtmlPdfKitDelegate>

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIWebView *naWebView;
@property (strong, nonatomic) BNHtmlPdfKit *htmlPdfKit;
@property (strong, nonatomic) UIView *animationView;

@end

@implementation NADetailsViewController

+ (NADetailsViewController *)create {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    return  [storyboard instantiateViewControllerWithIdentifier:@"NADetailsViewController"];
}

//------------------------------------------------------------------------------------------
#pragma mark - Life Cyrcle
//------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naWebView.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
//    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self loadURL];
}

- (void)save {
    if (![Helper connectedToInternet]) {
        return;
    }
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [self startAnimating];
    if (self.newsList.saved) {
        NSString *filePath = [Helper createFilePath: self.newsList.newsID];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self.navigationItem.rightBarButtonItem setTitle:@"Save"];
           [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            self.newsList.saved = NO;
            [self stopAnimating];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];
            [self.modelManager.coreDataManager saveContext];
        }
        return;
    }
    self.newsList.saved = YES;
    [self createPdf:self.newsList.newsID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------------------

- (void)loadURL {
    NSString *filePath = [Helper createFilePath: self.newsList.newsID];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        [self.naWebView loadData:data MIMEType: @"application/pdf" textEncodingName: @"" baseURL:[NSURL URLWithString:@"google.com"]];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:self.newsList.link];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.naWebView loadRequest:urlRequest];
}

- (void)createPdf:(NSString *)newsID {
    _htmlPdfKit = [[BNHtmlPdfKit alloc] init];
    _htmlPdfKit.delegate = self;
    _htmlPdfKit.pageSize = BNPageSizeCustom;
    _htmlPdfKit.customPageSize = CGSizeMake(375, 1000);
    [_htmlPdfKit saveUrlAsPdf:[NSURL URLWithString:self.newsList.link] toFile: [Helper createFilePath: newsID]];
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

//------------------------------------------------------------------------------------------
#pragma mark - WebView Delegate
//------------------------------------------------------------------------------------------

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)htmlPdfKit:(BNHtmlPdfKit *)htmlPdfKit didSavePdfFile:(NSString *)file {
    [self stopAnimating];
    [self.modelManager.coreDataManager saveContext];
    [self.navigationItem.rightBarButtonItem setTitle:@"Remove"];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
}

@end

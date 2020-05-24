//
//  NADetailsViewController.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/16/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NADetailsViewController.h"
#import "Helper.h"

@interface NADetailsViewController () <UIWebViewDelegate>

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIWebView *naWebView;

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
    // Do any additional setup after loading the view.

    [self loadURL];
    self.naWebView.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];

}

- (void)save {
    
    // Determile cache file path
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],self.link];
//
//    // Download and write to file
//    NSURL *url = [NSURL URLWithString:self.link];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    [urlData writeToFile:filePath atomically:YES];

    // Load file in UIWebView
//    [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------------------

- (void)loadURL {
    
    NSString *filePath = [Helper createFilePath: self.link];
    NSLog(@"filepath: %@", filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        [self.naWebView loadData:data MIMEType: @"application/pdf" textEncodingName: @"" baseURL:[NSURL URLWithString:@"google.com"]];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:self.link];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.naWebView loadRequest:urlRequest];
}
//------------------------------------------------------------------------------------------
#pragma mark - WebView Delegate
//------------------------------------------------------------------------------------------

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webview finished%i", webView.isLoading);
    if (webView.isLoading){
        return;
    }
    
    NSLog(@"%f", webView.scrollView.contentSize.height);
}

@end

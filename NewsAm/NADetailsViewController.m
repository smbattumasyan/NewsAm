//
//  NADetailsViewController.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/16/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NADetailsViewController.h"

@interface NADetailsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *naWebView;


@end

@implementation NADetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSURL *url = [NSURL URLWithString:self.link];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.naWebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

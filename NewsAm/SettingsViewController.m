//
//  SettingsViewController.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 5/23/20.
//  Copyright © 2020 Smbat Tumasyan. All rights reserved.
//

#import "SettingsViewController.h"
#import "Helper.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISlider *frequencySlider;

@end

@implementation SettingsViewController

//------------------------------------------------------------------------------------------
#pragma mark - Life Cyrcle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.frequencySlider setContinuous: NO];
    [self.frequencySlider setValue:[Helper valueFromUserDefaults:@"updateFrequency"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:@"Settings"];
}

//------------------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------------------

- (IBAction)frequencySliderAction:(UISlider *)sender {
    [Helper saveToUserDefaults:sender.value forKey:@"updateFrequency"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateByTimer" object:self];
}


@end

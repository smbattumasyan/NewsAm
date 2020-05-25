//
//  NATableViewCell.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NATableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "Helper.h"

@interface NATableViewCell ()

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel     *newsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *newsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation NATableViewCell

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------
- (void)awakeFromNib {
    [super awakeFromNib];
    self.newsImageView.layer.cornerRadius = 8.f;
    self.newsImageView.clipsToBounds = YES;
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)saveButtonAction:(UIButton *)sender {
    if (![Helper connectedToInternet]) {
        return;
    }
    self.save();
}

- (void)setANews:(NewsList *)aNews {
    _aNews = aNews;
    self.newsNameLabel.text        = _aNews.name;
    self.newsDescriptionLabel.text = _aNews.newsDescription;
    self.backgroundColor = _aNews.newItem ? [[UIColor yellowColor] colorWithAlphaComponent:0.1] : [UIColor whiteColor];
    NSURL *imageURL          = [NSURL URLWithString:_aNews.imgUrl];
    [self.newsImageView sd_setImageWithURL:imageURL];
    [self.saveButton setSelected:_aNews.saved];
}

@end

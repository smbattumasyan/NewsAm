//
//  NATableViewCell.m
//  NewsAm
//
//  Created by Smbat Tumasyan on 11/15/16.
//  Copyright © 2016 Smbat Tumasyan. All rights reserved.
//

#import "NATableViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface NATableViewCell ()

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel     *newsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *newsDescriptionLabel;

@end

@implementation NATableViewCell

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setANews:(NewsList *)aNews {
    _aNews = aNews;
    self.newsNameLabel.text        = _aNews.name;
    self.newsDescriptionLabel.text = _aNews.newsDescription;
    NSURL *imageURL          = [NSURL URLWithString:_aNews.imgUrl];
//    self.newsImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    [self.newsImageView sd_setImageWithURL:imageURL];
}

@end

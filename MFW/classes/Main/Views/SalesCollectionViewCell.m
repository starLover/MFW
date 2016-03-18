//
//  SalesCollectionViewCell.m
//  MFW
//
//  Created by wanghongxiao on 16/3/18.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "SalesCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface SalesCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *bigLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation SalesCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMainModel:(MainModel *)mainModel{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:mainModel.thumbnail]];
    self.bigLabel.text = mainModel.title;
    self.timeLabel.text = mainModel.sub_title_text;
    self.priceLabel.text = [NSString stringWithFormat:@"%@起/人", mainModel.price];
}

@end

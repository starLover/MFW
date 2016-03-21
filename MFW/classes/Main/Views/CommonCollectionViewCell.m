//
//  CommonCollectionViewCell.m
//  MFW
//
//  Created by wanghongxiao on 16/3/18.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "CommonCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@interface CommonCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *bigLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallLabel1;

@end
@implementation CommonCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMainModel:(MainModel *)mainModel{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:mainModel.img_url]];
    self.bigLabel.text = mainModel.title;
    self.smallLabel1.text = mainModel.sub_title;
}




@end

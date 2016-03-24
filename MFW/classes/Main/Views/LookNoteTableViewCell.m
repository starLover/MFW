//
//  LookNoteTableViewCell.m
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "LookNoteTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface LookNoteTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *lookCount;


@end

@implementation LookNoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMainModel:(MainModel *)mainModel{
    self.titleLable.text = mainModel.title;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:mainModel.logo]];
    self.headImage.layer.cornerRadius = 20.0;
    self.headImage.clipsToBounds = YES;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.thumbnail]];
    self.lookCount.text = [NSString stringWithFormat:@"%@浏览", mainModel.num_visit];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

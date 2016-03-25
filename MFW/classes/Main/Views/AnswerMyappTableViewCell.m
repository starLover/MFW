//
//  AnswerMyappTableViewCell.m
//  MFW
//
//  Created by wanghongxiao on 16/3/24.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "AnswerMyappTableViewCell.h"

@interface AnswerMyappTableViewCell ()


@end
@implementation AnswerMyappTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMainModel:(MainModel *)mainModel{
    self.authorImage.layer.cornerRadius = 25;
    self.authorImage.clipsToBounds = YES;
    self.titleLabel.text = mainModel.title;
    self.answerLabel.text = [NSString stringWithFormat:@"%@回答 %@浏览", mainModel.anum, mainModel.pv];
    self.placeLabel.text = mainModel.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

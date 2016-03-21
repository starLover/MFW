//
//  CollectionViewCell.m
//  MFW
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "CollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation CollectionViewCell

- (void)setModel:(AlubmModel *)model{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.simg] placeholderImage:[UIImage imageNamed:@"coffee"]];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageView];
        
    }
    return self;
}
// 自定义Layout
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    _imageView.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height);
    
}

@end

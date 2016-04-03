//
//  LZ_DetailBobyTableViewCell.m
//  MFW
//
//  Created by scjy on 16/3/30.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "LZ_DetailBobyTableViewCell.h"
#import "UIView+SDAutoLayout.h"

@implementation LZ_DetailBobyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    UIImageView *view = [UIImageView new];
    UILabel *view1 = [UILabel new];
    UILabel *view2 = [UILabel new];
    UILabel *view3 = [UILabel new];
    UILabel *view4 = [UILabel new];
    UILabel *view5 = [UILabel new];
    self.view = view;
    self.view1 = view1;
    self.view2 = view2;
    self.view3 = view3;
    self.view4 = view4;
    self.view5 = view5;
//    view.backgroundColor = [UIColor redColor];
//    view1.backgroundColor = [UIColor yellowColor];
//    view2.backgroundColor = [UIColor darkGrayColor];
//    view3.backgroundColor = [UIColor orangeColor];
//    view4.backgroundColor = [UIColor greenColor];
//    view5.backgroundColor = [UIColor blueColor];
    
    [self.contentView addSubview:view];
    [self.contentView addSubview:view1];
    [self.contentView addSubview:view2];
    [self.contentView addSubview:view3];
    [self.contentView addSubview:view4];
//    [self.contentView addSubview:view5];
    
    view.sd_layout .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(50)
    .heightIs(50);
    
    view1.sd_layout
    .leftSpaceToView(view, 10)
    .topEqualToView(view)
    .widthRatioToView(self.contentView, 0.4)
    .heightRatioToView(view, 0.4);
    
    view3.sd_layout
    .leftSpaceToView(view1,10)
    .topEqualToView(view)
    .rightSpaceToView(self.contentView, 10)
    .heightRatioToView(view1,1);
    
    view2.sd_layout
    .leftEqualToView(view1)
    .topSpaceToView(view1, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    
    view4.sd_layout.leftEqualToView(view2).topSpaceToView(view2, 10).heightIs(30).widthRatioToView(view2, 1);
    
    view5.sd_layout.leftSpaceToView(view4, 10).topEqualToView(view4).rightSpaceToView(self.contentView, 10).heightRatioToView(view4, 1);
    
    
    
    [self setupAutoHeightWithBottomView:view4 bottomMargin:10];
}

@end




























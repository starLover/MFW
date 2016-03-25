//
//  TravelWorldTableViewCell.m
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "TravelWorldTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

@interface TravelWorldTableViewCell ()
@property(nonatomic, strong) UIButton *headBtn;
@property(nonatomic, strong) UILabel *authorLabel;
@property(nonatomic, strong) UILabel *gradeLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIButton *bigImageBtn;
@property(nonatomic, strong) UILabel *latLngLabel;
@property(nonatomic, strong) UILabel *hearLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UIImageView *bigImageView;
@end

@implementation TravelWorldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config{
    [self addSubview:self.headBtn];
    [self addSubview:self.authorLabel];
    [self addSubview:self.gradeLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.bigImageView];
    [self.bigImageView addSubview:self.bigImageBtn];
    [self addSubview:self.placeLabel];
    [self addSubview:self.latLngLabel];
    [self addSubview:self.hearLabel];
    [self addSubview:self.contentLabel];
}

- (void)setMainModel:(MainModel *)mainModel{
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:mainModel.logo] forState:UIControlStateNormal];
    self.authorLabel.text = mainModel.name;
    self.gradeLabel.text = [NSString stringWithFormat:@"Lv%@", mainModel.level];
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    double time = timeInterval - [mainModel.ctime doubleValue];
    NSString *timeString;
    NSInteger value = 0;
    if (time > 3600) {
        value = time / 3600;
        timeString = [NSString stringWithFormat:@"%lu小时以前", (long)value];
    } else if (time > 60 && time < 3600) {
        value = time / 60;
        timeString = [NSString stringWithFormat:@"%lu分钟以前", (long)value];
    } else if (time > 0 && time <= 3600){
        timeString = @"刚刚";
    }
    self.timeLabel.text = timeString;
    self.bigImageView.frame = CGRectMake(0, 55, kScreenWidth, kScreenWidth / ([mainModel.width doubleValue] / [mainModel.height doubleValue]));
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.oimg]];
    self.bigImageBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth / ([mainModel.width doubleValue] / [mainModel.height doubleValue]));
    self.latLngLabel.text = [NSString stringWithFormat:@"N%.f°,W%.f°", [mainModel.lat doubleValue], [mainModel.lng doubleValue]];
    //图片下面控件高度
    self.placeLabel.frame = CGRectMake(30, self.bigImageBtn.frame.size.height + 55 + 16, 60, 20);
    self.latLngLabel.frame = CGRectMake(100, self.bigImageBtn.frame.size.height + 55 + 10, 130, 30);
    self.hearLabel.frame = CGRectMake(kScreenWidth - 130, self.bigImageBtn.frame.size.height + 55 + 10, 100, 30);
    self.hearLabel.text = [NSString stringWithFormat:@"附近有%@条", mainModel.num_lbs_weng];
    if (mainModel.content.length > 0) {
        self.contentLabel.frame = CGRectMake(30, kScreenWidth / ([mainModel.width doubleValue] / [mainModel.height doubleValue]) + 55 + 10 + 40, kScreenWidth - 60, [self getTextHeight:mainModel.content]);
        self.contentLabel.text = mainModel.content;
    }
}

- (CGFloat)getIamgeHeight:(NSString *)height{
    return self.bigImageBtn.frame.size.height + 55 + 10;
}
- (CGFloat)getTextHeight:(NSString *)text{
    CGSize size = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0]} context:nil].size;
    return size.height;
}
- (CGFloat)getCellHeight:(NSString *)text imageHeight:(CGFloat)height1{
    CGFloat height = 0;
    if (text.length > 0) {
        CGFloat textHeight = [self getTextHeight:text];
        height = 55 + height1 + textHeight + 50;
        return height;
    }
    height = 55 + height1 + 50;
    return height;
}
#pragma mark    ------------   LazyLoading

- (UIButton *)headBtn{
    if (!_headBtn) {
        self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headBtn.frame = CGRectMake(30, 10, 40, 40);
        self.headBtn.layer.cornerRadius = 20;
        self.headBtn.clipsToBounds = YES;
    }
    return _headBtn;
}
- (UILabel *)authorLabel{
    if (!_authorLabel) {
        self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, kScreenWidth / 3, 20)];
        
    }
    return _authorLabel;
}
- (UILabel *)gradeLabel{
    if (!_gradeLabel) {
        self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, kScreenWidth / 3, 20)];
        self.gradeLabel.textColor = [UIColor orangeColor];
    }
    return _gradeLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 130, 20, 100, 20)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIButton *)bigImageBtn{
    if (!_bigImageBtn) {
        self.bigImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bigImageBtn.frame = CGRectMake(0, 55, kScreenWidth, 100);
        
    }
    return _bigImageBtn;
}
- (UIImageView *)bigImageView{
    if (!_bigImageView) {
        self.bigImageView = [[UIImageView alloc] init];
    }
    return _bigImageView;
}
- (UILabel *)placeLabel{
    if (!_placeLabel) {
        self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 160, 40, 30)];
        self.placeLabel.textAlignment = NSTextAlignmentCenter;
        self.placeLabel.textColor = [UIColor whiteColor];
        self.placeLabel.font = [UIFont systemFontOfSize:13.0];
        self.placeLabel.backgroundColor = [UIColor orangeColor];
        self.placeLabel.layer.cornerRadius = 2;
        self.placeLabel.clipsToBounds = YES;
    }
    return _placeLabel;
}

- (UILabel *)latLngLabel{
    if (!_latLngLabel) {
        self.latLngLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 160, 130, 30)];
    }
    return _latLngLabel;
}
- (UILabel *)hearLabel{
    if (!_hearLabel) {
        self.hearLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 130, 160, 100, 30)];
        self.hearLabel.textAlignment = NSTextAlignmentCenter;
        self.hearLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.hearLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _hearLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

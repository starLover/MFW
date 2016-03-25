//
//  TravelWorldTableViewCell.h
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface TravelWorldTableViewCell : UITableViewCell
@property(nonatomic, strong) MainModel *mainModel;
@property(nonatomic, strong) UILabel *placeLabel;
- (CGFloat)getCellHeight:(NSString *)text imageHeight:(CGFloat)height1;
@end

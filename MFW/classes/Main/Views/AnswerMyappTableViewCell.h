//
//  AnswerMyappTableViewCell.h
//  MFW
//
//  Created by wanghongxiao on 16/3/24.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface AnswerMyappTableViewCell : UITableViewCell
@property(nonatomic, strong) MainModel *mainModel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *authorImage;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;

@end

//
//  LookNoteTableViewCell.h
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface LookNoteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property(nonatomic, strong) MainModel *mainModel;
@end

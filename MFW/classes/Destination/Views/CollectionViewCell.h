//
//  CollectionViewCell.h
//  MFW
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlubmModel.h"

@interface CollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)AlubmModel *alubmModel;

@end

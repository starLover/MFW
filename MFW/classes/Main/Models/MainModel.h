//
//  MainModel.h
//  MFW
//
//  Created by wanghongxiao on 16/3/17.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *jump_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *sub_title_text;
@property (nonatomic, copy) NSString *sub_title_url;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *sub_title;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price_suffix;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *num_pois;
@property (nonatomic, copy) NSNumber *num_visit;
@property (nonatomic, copy) NSString *myId;
@property (nonatomic, copy) NSNumber *level;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *oimg;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *num_lbs_weng;
@property (nonatomic, copy) NSString *num_fav;

@end

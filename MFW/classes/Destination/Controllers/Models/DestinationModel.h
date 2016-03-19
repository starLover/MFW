//
//  DestinationModel.h
//  MFW
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DestinationModel : NSObject
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *jump_url;
@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *distance;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *type_id;
@property(nonatomic,copy)NSString *header_img;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSNumber *num_album;
@property(nonatomic,copy)NSNumber *num;
@property(nonatomic,copy)NSString *map_provider;



@end

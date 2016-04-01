//
//  LZBuzzTool.h
//  MFW
//
//  Created by scjy on 16/3/31.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZBuzz.h"

@interface LZBuzzTool : NSObject
+ (NSArray *)buzzs;
+ (void)addBuzz:(LZBuzz *)buzz;
+ (void)deleteBuzz:(NSUInteger)row;
@end

//
//  HTools.h
//  MFW
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTools : NSObject
+ (CGFloat)getWidthWithText:(NSString *)text;
+ (CGFloat )getTextWidthWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)textFont;
@end

//
//  HTools.m
//  MFW
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HTools.h"

@implementation HTools
+ (CGFloat)getWidthWithText:(NSString *)text{
    CGRect width = [text boundingRectWithSize:CGSizeMake(300, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    return width.size.width;
}
+ (CGFloat )getTextWidthWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)textFont{
    //    CGFloat textHeight;
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]} context:nil];
    return textRect.size.width;
    
}
@end

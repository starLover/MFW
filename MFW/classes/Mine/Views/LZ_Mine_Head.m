//
//  LZ_Mine_Head.m
//  MFW
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZ_Mine_Head.h"
@interface LZ_Mine_Head()



@end
@implementation LZ_Mine_Head
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"LZ_Mine_Head" owner:self options:nil] lastObject];
//        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);

    }
    return self;;
}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super initWithCoder:aDecoder]) {
//        
//        [self creatView];
//    self = [[[NSBundle mainBundle] loadNibNamed:@"LZ_Mine_Head" owner:self options:nil] lastObject];
//    }
//
//    
//    return self;
//}
//- (void)creatView{
//   [[NSBundle mainBundle] loadNibNamed:@"LZ_Mine_Head" owner:self options:nil];
//    [self addSubview:self.view];
//    
//    self.view.frame = self.bounds; //填一下自动布局的坑！最好要写这一句
//}
@end




























//
//  LZ_DetailHeadTableViewCell.m
//  MFW
//
//  Created by scjy on 16/3/30.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "LZ_DetailHeadTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface LZ_DetailHeadTableViewCell ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *phoneNumber;

/** <bmob> */
@property (nonatomic, strong) BmobUser *bUser;

@end

@implementation LZ_DetailHeadTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    //    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 3 + 20)];
    view.backgroundColor = [UIColor darkGrayColor];
    [view sd_addSubviews:@[self.imageView,self.phoneNumber]];
    //    [view addSubview:self.imageView];
    //    [view addSubview:self.phoneNumber];
    
    self.imageView = [UIImageView new];
    self.imageView.backgroundColor = [UIColor redColor];
    self.imageView.sd_layout.topSpaceToView(self.contentView, 64).widthRatioToView(self.contentView, 0.3).heightRatioToView(self.contentView, 0.3).leftSpaceToView(self.contentView, 0.3);
    
    self.bUser = [BmobUser getCurrentUser];
    self.imageView.layer.cornerRadius     = 50;
    self.imageView.clipsToBounds          = YES;
    self.imageView.image = [UIImage imageWithContentsOfFile:kPath];
    
    self.phoneNumber = [UILabel new];
    self.phoneNumber.sd_layout.topSpaceToView(self.imageView, 10).widthRatioToView(self.imageView, 1).leftSpaceToView(self.contentView, 1/3);
    self.phoneNumber.text = self.bUser.username;
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.imageView.frame;
    [btn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
}

-(void)open{
    UIImagePickerController *pickerImage=[[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.editing  = YES;
//        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img   = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = img;
    NSData *data   = UIImageJPEGRepresentation(img, 1);
    [data writeToFile:kPath atomically:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end

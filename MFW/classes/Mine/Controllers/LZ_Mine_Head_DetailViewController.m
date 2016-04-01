//
//  LZ_Mine_Head_DetailViewController.m
//  
//
//  Created by scjy on 16/3/18.
//
//

#import "LZ_Mine_Head_DetailViewController.h"
#import <BmobSDK/Bmob.h>
#import <UIImageView+WebCache.h>

@interface LZ_Mine_Head_DetailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumber;

/** <bmob> */
@property (nonatomic, strong) BmobUser *bUser;

@end

@implementation LZ_Mine_Head_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bUser = [BmobUser getCurrentUser];
    self.imageView.layer.cornerRadius     = 50;
    self.imageView.clipsToBounds          = YES;
    UIImage *image = [UIImage imageWithContentsOfFile:kPath];
    NSString *avatar_hd = [[NSUserDefaults standardUserDefaults] valueForKey:@"avatar_hd"];
    if (image) {
        self.imageView.image = image;
    }else{
        if (avatar_hd) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:avatar_hd] placeholderImage:[UIImage imageNamed:@"phloder"]];
        }else{
            self.imageView.image = [UIImage imageNamed:@"phloder"];
            
        }
    }
    [self.phoneNumber setTitle:self.bUser.username forState:UIControlStateNormal];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.imageView.frame;
    [btn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)open{
    UIImagePickerController *pickerImage=[[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.editing  = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
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




























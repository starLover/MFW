//
//  LZ_Mine_Head_DetailViewController.m
//  
//
//  Created by scjy on 16/3/18.
//
//

#import "LZ_Mine_Head_DetailViewController.h"

@interface LZ_Mine_Head_DetailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LZ_Mine_Head_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.layer.cornerRadius = 30;
    self.imageView.clipsToBounds      = YES;
    self.imageView.image              = [UIImage imageWithContentsOfFile:kPath];
    UITapGestureRecognizer *tap       = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(open)];
    [self.imageView addGestureRecognizer:tap];
    [self.view addSubview:self.imageView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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




























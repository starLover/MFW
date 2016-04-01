//
//  LZ_DetailTableViewController.m
//  MFW
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "LZ_DetailTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "LZ_DetailBobyTableViewCell.h"
#import "LZ_showLiveViewController.h"
#import <UIImageView+WebCache.h>
#import "LZBuzzTool.h"
#import "LZBuzz.h"

@interface LZ_DetailTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImageView *imageHeadView;
@property (strong, nonatomic) UILabel *phoneNumber;
@property (nonatomic, strong) BmobUser *bUser;
@property (nonatomic, strong) UIButton *buttonView;
@property (nonatomic, strong) NSArray *buzzs;

@end

@implementation LZ_DetailTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 3 + 20)];
    view.backgroundColor = [UIColor darkGrayColor];
//    [view sd_addSubviews:@[self.imageHeadView,self.phoneNumber]];
    
    self.imageHeadView = [UIImageView new];
    self.imageHeadView.backgroundColor = [UIColor redColor];
    self.imageHeadView.sd_layout.topSpaceToView(self.tableView, 64).widthRatioToView(self.tableView, 0.3).heightRatioToView(self.tableView, 0.3).leftSpaceToView(self.tableView, 0.3);
    
    self.phoneNumber = [UILabel new];
    self.phoneNumber.sd_layout.topSpaceToView(self.imageHeadView, 10).widthRatioToView(self.imageHeadView, 1).leftSpaceToView(self.tableView, 1/3);
    
    self.bUser = [BmobUser getCurrentUser];
    self.imageHeadView.layer.cornerRadius     = 50;
    self.imageHeadView.clipsToBounds          = YES;
    UIImage *image = [UIImage imageWithContentsOfFile:kPath];
    NSString *avatar_hd = [[NSUserDefaults standardUserDefaults] valueForKey:@"avatar_hd"];
    if (image) {
        self.imageHeadView.image = image;
    }else{
        if (avatar_hd) {
            [self.imageHeadView sd_setImageWithURL:[NSURL URLWithString:avatar_hd] placeholderImage:[UIImage imageNamed:@"phloder"]];
        }else{
            self.imageHeadView.image = [UIImage imageNamed:@"phloder"];
            
        }
    }
    self.phoneNumber.text = self.bUser.username;
    
    self.imageHeadView.frame = CGRectMake(10, 10, 100, 100);
    self.phoneNumber.frame = CGRectMake(120, 33, 200, 44);
    [view addSubview:self.imageHeadView];
    [view addSubview:self.phoneNumber];
    self.tableView.tableHeaderView = view;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.imageHeadView.frame;
    [btn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.tableView registerClass:[LZ_DetailBobyTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];


    //在导航栏右边添加编辑按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonView.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60, 40, 40);
    buttonView.layer.cornerRadius     = 20;
    buttonView.clipsToBounds          = YES;
    buttonView.backgroundColor = [UIColor redColor];
    [window addSubview:buttonView];
    self.buttonView = buttonView;
    [buttonView addTarget:self action:@selector(showLive) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *buzzs = [LZBuzzTool buzzs];
    self.buzzs = buzzs;
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.buttonView removeFromSuperview];
}
- (void)showLive{
    LZ_showLiveViewController *lz = [LZ_showLiveViewController new];
    [self.navigationController pushViewController:lz animated:YES];
    
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
    self.imageHeadView.image = img;
    NSData *data   = UIImageJPEGRepresentation(img, 1);
    [data writeToFile:kPath atomically:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    return self.buzzs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZ_DetailBobyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    self.bUser = [BmobUser getCurrentUser];
    cell.view.layer.cornerRadius     = 25;
    cell.view.clipsToBounds          = YES;
    UIImage *image = [UIImage imageWithContentsOfFile:kPath];
    NSString *avatar_hd = [[NSUserDefaults standardUserDefaults] valueForKey:@"avatar_hd"];
    if (image) {
        cell.view.image = image;
    }else{
        if (avatar_hd) {
            [cell.view sd_setImageWithURL:[NSURL URLWithString:avatar_hd] placeholderImage:[UIImage imageNamed:@"phloder"]];
        }else{
            cell.view.image = [UIImage imageNamed:@"phloder"];
            
        }
    }
    cell.view1.text = self.bUser.username;
    NSArray *buzzs = [LZBuzzTool buzzs];
    NSMutableArray * newMarray = [NSMutableArray array];
    NSEnumerator * enumerator = [buzzs reverseObjectEnumerator];
    id object = nil;
    while (object = [enumerator nextObject]) {
        [newMarray addObject:object];
    }
    LZBuzz *buzz = newMarray[indexPath.row];
    cell.view3.text = buzz.time;
    cell.view2.text = buzz.content;
    cell.view4.font = [UIFont systemFontOfSize:10];
    cell.view4.text = [NSString stringWithFormat:@"%@ %@",buzz.locality,buzz.name];
        

    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [LZBuzzTool deleteBuzz:(NSUInteger)indexPath];
    fSLog(@"%@",indexPath);
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

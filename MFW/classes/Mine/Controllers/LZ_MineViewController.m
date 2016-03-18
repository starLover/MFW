//
//  LZ_MineViewController.m
//  MFW
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZ_MineViewController.h"
#import "LZ_Mine_Head.h"
#import "LZ_Mine_Head_DetailViewController.h"

@interface LZ_MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <LIST> */
@property (nonatomic, strong) NSArray *List;
/** <head> */
@property (nonatomic, strong) LZ_Mine_Head *mineHead;
@end

@implementation LZ_MineViewController
- (void)loadView{
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mineHead = [[LZ_Mine_Head alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.mineHead;
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = self.mineHead.frame;
    [headBtn addTarget:self action:@selector(headAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableHeaderView addSubview:headBtn];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.List = @[@"蜜蜂商城",@"我的下载",@"我的收藏",@"我的订单",@"我的优惠券",@"我的点评",@"我的问答",@"我的活动"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.mineHead.imageView.layer.cornerRadius     = 30;
    self.mineHead.imageView.clipsToBounds          = YES;
    self.mineHead.imageView.image = [UIImage imageWithContentsOfFile:kPath];

}
- (void)headAction{
    LZ_Mine_Head_DetailViewController *lz = [LZ_Mine_Head_DetailViewController new];
    [self.navigationController pushViewController:lz animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.List.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentifier = @"LZ_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    cell.textLabel.text = self.List[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    fSLog(@"打不死的小强");
}

@end




























//
//  LZ_MineViewController.m
//  MFW
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZ_MineViewController.h"

@interface LZ_MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <LIST> */
@property (nonatomic, strong) NSArray *List;
@end

@implementation LZ_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.List = @[@"蜜蜂商城",@"我的下载",@"我的收藏",@"我的订单",@"我的优惠券",@"我的点评",@"我的问答",@"我的活动"];
    
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
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    fSLog(@"打不死的小强");
}

@end




























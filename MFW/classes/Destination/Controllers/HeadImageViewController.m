//
//  HeadImageViewController.m
//  MFW
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HeadImageViewController.h"
#import "HeadImageTableViewCell.h"
#import "DestinationViewController.h"
#import "DestinationModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface HeadImageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger num;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)NSMutableArray *poiArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *otherArray;
@property(nonatomic,strong)NSMutableArray *userArray;
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic, strong)NSMutableArray *outLogoArray;
@property(nonatomic,copy)NSNumber *userNum;


@end

@implementation HeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self requestModel];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark --------- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return self.poiArray.count;
//    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < self.poiArray.count) {
        DestinationModel *poiModel = self.poiArray[indexPath.row];
        cell.nameLabel.text = poiModel.name;
        DestinationModel *areaModel = self.areaArray[indexPath.row];
        cell.placeName.text = [NSString stringWithFormat:@"位于 %@",areaModel.name];
        DestinationModel *userNumModel = self.userArray[indexPath.row];
        cell.userNum.text = [NSString stringWithFormat:@"今天有 %@ 人浏览",userNumModel.user_number];
        //序号
        if (indexPath.row<9) {
            cell.sortLabel.text = [NSString stringWithFormat:@"0%lu",(long)indexPath.row+1];
            if (indexPath.row<3) {
                cell.sortLabel.backgroundColor = [UIColor redColor];
                cell.sortLabel.textColor = [UIColor whiteColor];
            }else{
                cell.sortLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
                cell.sortLabel.textColor = [UIColor redColor];
            }
        }else{
            cell.sortLabel.text = [NSString stringWithFormat:@"%lu",(long)indexPath.row+1];
        }
        //logo
        NSArray *array = self.outLogoArray[indexPath.row];
        if (array.count > 0) {
            for (NSInteger i = 0; i<array.count; i++) {
                DestinationModel *logoModel = array[i];
                UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(20+i*((kScreenWidth-150)/6 + 10), 61, (kScreenWidth-130)/6, (kScreenWidth-130)/6)];
                logoImage.layer.masksToBounds = YES;
                logoImage.layer.cornerRadius = (kScreenWidth-130)/12;
                [logoImage sd_setImageWithURL:[NSURL URLWithString:logoModel.logo] placeholderImage:nil];
                [cell.contentView addSubview:logoImage];

            }
        }
    }
        return cell;
}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight/4, kScreenWidth, kScreenHeight-kScreenHeight/4+54)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kScreenHeight/6;
    }
    return _tableView;
}
#pragma mark --------- 自定义BlackView
- (void)headViewAction{
    //view
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4)];
    blackView.backgroundColor = [UIColor blackColor] ;
    [self.view addSubview:blackView];
    //关闭按钮
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.frame = CGRectMake(kScreenWidth-80, 20 , 40, 44);
    [numBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [numBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:numBtn];
    //时间label
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth/3, 40)];
    timeLabel.text = @"过去24小时,";
    timeLabel.textColor = [UIColor whiteColor];
    [blackView addSubview:timeLabel];
    //人数Label
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth/3, 50)];
    numLabel.text = [self.userNum stringValue];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:26];
    [blackView addSubview:numLabel];
    //地点Label
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, kScreenWidth/2, 40)];
    DestinationModel *placeModel = self.otherArray[0];
    placeLabel.text = [NSString stringWithFormat:@"人，正在 %@ 旅行",placeModel.name];
    //label富文本文件
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:placeModel.name];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
//    placeLabel.attributedText =[NSString stringWithFormat:@"人，正在 %@ 旅行",str];
    placeLabel.textColor = [UIColor grayColor];
    placeLabel.font = [UIFont systemFontOfSize:14];
    [blackView addSubview:placeLabel];
    [blackView addSubview:self.segmentControl];
    
}
- (void)closeAction{
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---------  网络请求
- (void)requestModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [sessionManager GET:kHeaderImage parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSDictionary *dataDic = resultDic[@"data"];
        self.userNum = dataDic[@"user_number"];
        NSArray *blocksArray = dataDic[@"blocks"];
        
            self.dataDic = blocksArray[num];
            NSArray *list = self.dataDic[@"list"];
            for (NSDictionary *dic in list) {
                NSDictionary *poi = dic[@"poi"];
                NSDictionary *area = poi[@"area"];
                DestinationModel *poiModel = [[DestinationModel alloc]init];
                [poiModel setValuesForKeysWithDictionary:poi];
                [self.poiArray addObject:poiModel];
                DestinationModel *model = [[DestinationModel alloc]init];
                [model setValuesForKeysWithDictionary:area];
                [self.areaArray addObject:model];
                NSArray *array = dic[@"user_list"];
                
                NSMutableArray *outArray = [NSMutableArray new];
                if (array.count > 0) {
                    for (NSDictionary *dit in array) {
                        DestinationModel *logoModel = [[DestinationModel alloc] init];
                        [logoModel setValuesForKeysWithDictionary:dit];
                        [outArray addObject:logoModel];
                    }
                }
                [self.outLogoArray addObject:outArray];
                //
                DestinationModel *userModel = [[DestinationModel alloc]init];
                [userModel setValuesForKeysWithDictionary:dic];
                [self.userArray addObject:userModel];
            }

        NSDictionary *mdd = dataDic[@"mdd"];
        DestinationModel *model = [[DestinationModel alloc]init];
        [model setValuesForKeysWithDictionary:mdd];
        [self.otherArray addObject:model];
        [self.tableView reloadData];
        [self headViewAction];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark --------- segmentControl
- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        self.segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"餐厅",@"景点",@"购物"]];
        self.segmentControl.frame = CGRectMake(40, 120, kScreenWidth-80, 40);
        self.segmentControl.tintColor = [UIColor orangeColor];
        [self.segmentControl addTarget:self action:@selector(segmentControlChangeAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
- (void)segmentControlChangeAction:(UISegmentedControl *)segment{
    num = segment.selectedSegmentIndex;
    if (self.poiArray.count > 0) {
        [self.poiArray removeAllObjects];
    }
    if (self.areaArray.count > 0) {
        [self.areaArray removeAllObjects];
    }
    if (self.userArray .count > 0) {
        [self.userArray removeAllObjects];
    }
    if (self.outLogoArray.count > 0) {
        [self.outLogoArray removeAllObjects];
    }
    [self requestModel];
    }
#pragma mark --------------- Lazy
- (NSMutableArray *)poiArray{
    if (!_poiArray) {
        self.poiArray = [NSMutableArray new];
    }
    return _poiArray;
}
- (NSMutableArray *)userArray{
    if (_userArray == nil) {
        self.userArray = [NSMutableArray new];
    }
    return _userArray;
}
- (NSMutableArray *)areaArray{
    if (!_areaArray) {
        self.areaArray = [NSMutableArray new];
    }
    return _areaArray;
}

- (NSMutableArray *)outLogoArray{
    if (!_outLogoArray) {
        self.outLogoArray = [NSMutableArray new];
    }
    return _outLogoArray;
}
- (NSMutableArray *)otherArray{
    if (!_otherArray) {
        self.otherArray = [NSMutableArray new];
    }
    return _otherArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

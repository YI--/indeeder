//
//  YIem_Two_TabBar_Home_ViewController.m
//  indeed
//
//  Created by YIem on 16/10/13.
//  Copyright © 2016年 YIem. All rights reserved.
//

#import "YIem_Two_TabBar_Home_ViewController.h"
#import "YIem_Two_TableViewRight_TableViewCell.h"
#import "YIem_One_TabBar_Home_Did_ViewController.h"
#import "YIem_One_TabBar_Home_Model.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface YIem_Two_TabBar_Home_ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDataBaseInfo;



@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableViewRight;
@property (nonatomic, strong) NSMutableArray *dataBaseArr; // rightTableView 数据
@property (nonatomic, strong) NSMutableDictionary *param; // 数据请求字典


@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,retain)NSArray *currentCityArray;// 当前城市
@property (nonatomic,retain)NSArray *hotCityArray; // 热门城市
@property (nonatomic,retain)NSMutableArray *rightIndexArray; // 右边索引数组


@end

@implementation YIem_Two_TabBar_Home_ViewController

- (void)viewWillAppear:(BOOL)animated {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前没有网络" message:@"请检查你的网络状态1 " preferredStyle:UIAlertControllerStyleAlert];
        //            UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        //            [alert addAction:alert1];
        [self presentViewController:alert animated:YES completion:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
            
        }];
        
        
//        NSLog(@"NotReachable");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userDataBaseInfo  = [NSUserDefaults standardUserDefaults];
    NSString *job = [self.userDataBaseInfo
                     objectForKey:@"job"];
    self.param = [NSMutableDictionary dictionary];
    
    [self.param setValuesForKeysWithDictionary:@{@"format":@"json",@"v":@"2", @"useragent":@"iPhone", @"userip":@"0", @"co":@"cn", @"limit":@"100", @"fromage":@"7", @"q":job}];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.navigationItem.title = @"推荐";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.font = [UIFont fontWithName:@"SnellRoundhand-Black" size:(22)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"F i n d";
    self.navigationItem.titleView = label;
    [self dataBase];
//    [self dataBaseDBA];
    
    // TableView 左 城市
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3.5, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor blackColor];

    [self.view addSubview:_tableView];
    

    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    // TableView  右
    self.tableViewRight = [[UITableView alloc] initWithFrame:CGRectMake(_tableView.frame.origin.x + _tableView.frame.size.width, _tableView.frame.origin.y +64, self.view.frame.size.width - _tableView.frame.size.width, self.view.frame.size.height - 112) style:UITableViewStylePlain];
    self.tableViewRight.delegate = self;
    self.tableViewRight.dataSource = self;
    self.tableViewRight.bounces = NO;
    self.tableViewRight.backgroundColor = [UIColor cyanColor];
    self.tableViewRight.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewRight];
    
    [self.tableViewRight registerClass:[YIem_Two_TableViewRight_TableViewCell class] forCellReuseIdentifier:@"YIem_Two_TableViewRight_TableViewCell"];
    
//    [self.tableViewRight registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    
}

- (void)dataBaseDBA {
    
    self.dataBaseArr = [NSMutableArray array ];
    




    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
        dispatch_async(queue, ^{
            

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://api.indeed.com/ads/apisearch?publisher=9427261241958914" parameters:_param progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功

        
        for (NSDictionary *dic in [responseObject objectForKey:@"results"]) {
            

            
            
            YIem_One_TabBar_Home_Model *model = [[YIem_One_TabBar_Home_Model alloc] init];
            
            [model setValuesForKeysWithDictionary:dic];
            [self.dataBaseArr addObject:model];
        }
        

            [self.tableViewRight reloadData];


        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
//        NSLog(@"请求失败%@", (error));
    }];
            
            

        });
}

- (void)dataBase {
    self.rightIndexArray = [NSMutableArray array];
    self.sectionTitlesArray = [NSMutableArray array]; //区头字母数组
    self.dataArray = [NSMutableArray array]; //包含所有区数组的大数组
    self.currentCityArray = [NSMutableArray array]; // 当前城市
    self.hotCityArray = [NSMutableArray array]; // 热门城市
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSArray * allKeys = [self.dictionary allKeys];
    [self.sectionTitlesArray addObjectsFromArray:[allKeys sortedArrayUsingSelector:@selector(compare:)]];
    [self.sectionTitlesArray enumerateObjectsUsingBlock:^(NSString *zimu, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *smallArray = self.dictionary[zimu];
        [self.dataArray addObject:smallArray];
    }];
    [self.rightIndexArray addObjectsFromArray:self.sectionTitlesArray];
    //    [self.rightIndexArray insertObject:UITableViewIndexSearch atIndex:0];
    [self.sectionTitlesArray insertObject:@"热门" atIndex:0];
    [self.sectionTitlesArray insertObject:@"当前" atIndex:0];
    //    self.currentCityArray = @[self.currentCityString];
    self.hotCityArray = @[@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州"];
    NSString *city = [self.userDataBaseInfo objectForKey:@"city"];
    self.currentCityArray = @[city];
    [self.dataArray insertObject:self.hotCityArray atIndex:0];
    [self.dataArray insertObject:self.currentCityArray atIndex:0];
    
//        [self dataBaseDBA];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_tableView]) {
        
        return self.sectionTitlesArray.count;
    }else if([tableView isEqual:_tableViewRight]){
        
        return 1;
    }else {
        return 0;
    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//        return [self.dataArray[section]count];
    if ([tableView isEqual:_tableView]) {
        
        return [self.dataArray[section]count];
    }else if([tableView isEqual:_tableViewRight]){
        
        return self.dataBaseArr.count;
//        return 20;
    }else {
        return 0;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

//    return self.sectionTitlesArray[section];
    if ([tableView isEqual:_tableView]) {
        
        return self.sectionTitlesArray[section];
    }else if([tableView isEqual:_tableViewRight]){
        
        return nil;
    }else {
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_tableView]) {
        
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSArray *array = self.dataArray[indexPath.section];
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    
        // 默认选中 第一个
    static dispatch_once_t chengshi;
    dispatch_once(&chengshi, ^{
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    NSString *city = [self.userDataBaseInfo objectForKey:@"city"];

    [_param setValue:city forKey:@"l"];

    [self dataBaseDBA];
    });

        
    // 适配屏幕
    if ([UIScreen mainScreen].bounds.size.width == 320){
        CGFloat size = 13.5 - cell.textLabel.text.length;
        cell.textLabel.font = [UIFont systemFontOfSize:size];
    }else if ([UIScreen mainScreen].bounds.size.width == 375) {
        CGFloat size = 15.5 - cell.textLabel.text.length;
        cell.textLabel.font = [UIFont systemFontOfSize:size];
    }else if ([UIScreen mainScreen].bounds.size.width == 414) {
        CGFloat size = 17 - cell.textLabel.text.length;
        cell.textLabel.font = [UIFont systemFontOfSize:size];
    }
        
        
        return cell;
    }else if([tableView isEqual:_tableViewRight]){
        
        YIem_Two_TableViewRight_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YIem_Two_TableViewRight_TableViewCell" forIndexPath:indexPath];


        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
//        cell.model = nil;
            if (indexPath.row < [_dataBaseArr count]) {
                cell.model = [_dataBaseArr objectAtIndex:indexPath.row];
            }

        cell.layer.cornerRadius = 10;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else {
    
    
        return nil;

    }
//    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([tableView isEqual:_tableView]) {
        


        NSString *value = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [_param setValue:value forKey:@"l"];
        

        
        [self dataBaseDBA];

        [self.tableViewRight reloadData];

        
        
    }else if ([tableView isEqual:_tableViewRight]) {
        
        
        
        YIem_One_TabBar_Home_Did_ViewController *did = [[YIem_One_TabBar_Home_Did_ViewController alloc] init];
        
        
        
        
        [did setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

        UINavigationController *didNC = [[UINavigationController alloc] initWithRootViewController:did];
    
        [self presentViewController:didNC animated:YES completion:nil];
        did.dataModel = nil;
        if (indexPath.row < [_dataBaseArr count]) {
            did.dataModel = [_dataBaseArr objectAtIndex:indexPath.row];
        }

        // 职位情报！
        
    }else {

    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEqual:_tableView]) {

        return 44.0;
    }else if([tableView isEqual:_tableViewRight]){

        return 180.0;
    }else {
        return 44.0;
    }


}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
//        return self.rightIndexArray;
    if ([tableView isEqual:_tableView]) {
        
        return self.rightIndexArray;
    }else if([tableView isEqual:_tableViewRight]){
        
        return 0;
    }else {
        return 0;
    }
    
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

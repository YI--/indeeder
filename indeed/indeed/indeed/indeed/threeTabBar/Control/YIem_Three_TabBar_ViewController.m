//
//  YIem_Three_TabBar_ViewController.m
//  indeed
//
//  Created by YIem on 16/10/20.
//  Copyright © 2016年 YIem. All rights reserved.
//

#import "YIem_Three_TabBar_ViewController.h"
#import "AFNetworking.h"
#import "YIem_One_TabBar_Home_Model.h"
#import "YIem_One_TabBar_Home_TableViewCell.h"
#import "YIem_One_TabBar_Home_Did_ViewController.h"
#import "Reachability.h"


@interface YIem_Three_TabBar_ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataBaseArr;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YIem_Three_TabBar_ViewController


- (void)viewWillAppear:(BOOL)animated {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前没有网络" message:@"请检查你的网络状态1 " preferredStyle:UIAlertControllerStyleAlert];

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.font = [UIFont fontWithName:@"SnellRoundhand-Black" size:(22)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"S e a r c h *";
    self.navigationItem.titleView = label;
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    
    
    
    
    
    [self dataBase];
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor cyanColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.tableView registerClass:[YIem_One_TabBar_Home_TableViewCell class] forCellReuseIdentifier:@"One_TabBar_Home_TableViewCell"];
    

    
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataBaseArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YIem_One_TabBar_Home_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"One_TabBar_Home_TableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if (indexPath.row < [_dataBaseArr count]) {
        cell.model = [_dataBaseArr objectAtIndex:indexPath.row];
    }
    
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YIem_One_TabBar_Home_Did_ViewController *did = [[YIem_One_TabBar_Home_Did_ViewController alloc] init];
    [did setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    
    UINavigationController *didNC = [[UINavigationController alloc] initWithRootViewController:did];
    
    [self presentViewController:didNC animated:YES completion:nil];
    
    
    did.dataModel = nil;
    if (indexPath.row < [_dataBaseArr count]) {
        did.dataModel = [_dataBaseArr objectAtIndex:indexPath.row];
    }
    
    
}





- (void)dataBase {
    
    self.dataBaseArr = [NSMutableArray array ];
    NSDictionary *param = @{@"format":@"json",@"v":@"2", @"useragent":@"iPhone", @"userip":@"0", @"co":@"cn", @"limit":@"50", @"fromage":@"7", @"q":self.str};
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://api.indeed.com/ads/apisearch?publisher=9427261241958914" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        
        for (NSDictionary *dic in [responseObject objectForKey:@"results"]) {
            
            YIem_One_TabBar_Home_Model *model = [[YIem_One_TabBar_Home_Model alloc] init];
            
            [model setValuesForKeysWithDictionary:dic];
            [self.dataBaseArr addObject:model];
        }
        
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
//        NSLog(@"请求失败%@", (error));
    }];
}
- (void)leftAction {
    [self dismissViewControllerAnimated:YES completion:nil];
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

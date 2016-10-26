//
//  YIem_One_TabBar_Home_ViewController.m
//  indeed
//
//  Created by YIem on 16/10/13.
//  Copyright © 2016年 YIem. All rights reserved.
//

#import "YIem_One_TabBar_Home_ViewController.h"
#import "YIem_One_TabBar_Home_TableViewCell.h"
#import "YIem_One_TabBar_Home_Model.h"
#import "YIem_One_TabBar_Home_Did_ViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface YIem_One_TabBar_Home_ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSUserDefaults *userDataBaseInfo;


@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) UIView *vi;
@property (nonatomic, strong) UITextField *inputTextJob;
@property (nonatomic, strong) UITextField *inputTextCity;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataBaseArr;
@end

@implementation YIem_One_TabBar_Home_ViewController


- (void)viewWillAppear:(BOOL)animated {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStart"];
    
    
//        NSUserDefaults *userLogin = [NSUserDefaults standardUserDefaults];
        self.userDataBaseInfo  = [NSUserDefaults standardUserDefaults];
        
        [self.userDataBaseInfo setBool:YES forKey:@"login"];
    
    
        __weak typeof(self) weakself = self;
        self.alert = [UIAlertController alertControllerWithTitle:@"输入职位、城市" message:@"城市可以不填" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"点击了取消按钮");
            [[NSNotificationCenter defaultCenter]removeObserver:weakself name:UITextFieldTextDidChangeNotification object:nil];
        }];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"点击了好的按钮");
            
            // 判断App是否第一次运行
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];

            
            // 判断是走默认地方还是 用户输入
            if ([[[self.alert textFields]firstObject]text].length > 0) {
                [self.userDataBaseInfo setObject:[[[self.alert textFields] firstObject] text] forKey:@"job"];
            }else {
                [self.userDataBaseInfo setObject:@"iOS" forKey:@"job"];

            }
            if ([[[self.alert textFields]lastObject]text].length >= 2) {
                [self.userDataBaseInfo setObject:[[[self.alert textFields] lastObject] text] forKey:@"city"];

            }else {
                [self.userDataBaseInfo setObject:@"上海" forKey:@"city"];

            }

            
            [self.userDataBaseInfo setBool:NO forKey:@"login"];
            [self dataBase];
            [[NSNotificationCenter defaultCenter]removeObserver:weakself name:UITextFieldTextDidChangeNotification object:nil];
        }];
        
        // 先冻结 “好的” 按钮，需要用户输入用户名和密码后再启用
        [defaultAction setEnabled:NO];
        
        [self.alert addAction:cancleAction];
        [self.alert addAction:defaultAction];
        
        // 添加文本输入框
        [self.alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入职位";
            [[NSNotificationCenter defaultCenter]addObserver:weakself selector:@selector(handleTextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        }];
        
        // 添加文本输入框
        [self.alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入城市";
//            [textField setSecureTextEntry:YES];
        }];
        
        [self presentViewController:self.alert animated:YES completion:nil];
    }else {
        
        [self dataBase];
        
    }
    
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
- (void)handleTextFieldDidChanged:(NSNotification *)notification {
    

    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *textField = alertController.textFields.firstObject;
        UIAlertAction *action  = alertController.actions.lastObject;
        action.enabled = textField.text.length > 0;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    
    

    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.font = [UIFont fontWithName:@"SnellRoundhand-Black" size:(22)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"R e c o m m e n d";
    self.navigationItem.titleView = label;
    

    if ([self.userDataBaseInfo boolForKey:@"login"] != YES) {
        
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor cyanColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YIem_One_TabBar_Home_TableViewCell class] forCellReuseIdentifier:@"YIem_One_TabBar_Home_TableViewCell"];

    [self.view addSubview:_tableView];

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataBaseArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YIem_One_TabBar_Home_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YIem_One_TabBar_Home_TableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    cell.model = nil;
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

/**
 *  数据请求
 */
- (void)dataBase {
 
    
    self.dataBaseArr = [NSMutableArray array ];
    self.userDataBaseInfo  = [NSUserDefaults standardUserDefaults];

    
    NSString *job = [self.userDataBaseInfo objectForKey:@"job"];
    NSString *city = [self.userDataBaseInfo objectForKey:@"city"];
    
    
    NSDictionary *param = @{@"format":@"json",@"v":@"2", @"useragent":@"iPhone", @"userip":@"0", @"co":@"cn", @"limit":@"50", @"fromage":@"7", @"q":job, @"l":city};
    
    
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

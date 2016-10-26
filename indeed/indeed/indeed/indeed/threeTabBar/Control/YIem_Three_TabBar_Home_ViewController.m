//
//  YIem_Three_TabBar_Home_ViewController.m
//  indeed
//
//  Created by YIem on 16/10/13.
//  Copyright © 2016年 YIem. All rights reserved.
//

#import "YIem_Three_TabBar_Home_ViewController.h"
#import <StoreKit/StoreKit.h>
#import "YIem_Three_TabBar_ViewController.h"
#import "Reachability.h"

@interface YIem_Three_TabBar_Home_ViewController ()<UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) NSUserDefaults *userDataBaseInfo;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIAlertController *alert;

@end

@implementation YIem_Three_TabBar_Home_ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    // 下载 Reachability.h Reachability.m 文件
    // 导入头文件 #import "Reachability.h"
    // 导入 SystemConfiguration.framework 库文件
    
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
    label.text = @"S e t t i n g s";
    self.navigationItem.titleView = label;
    
    self.dataArr = @[@"修改职位信息", @"评价一下", @"关于APP", @"支持", @"Email"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.bounces = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
    
    
    UIView *TabVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height / 3)];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TabVIew.frame.size.width, TabVIew.frame.size.height)];
    img.image = [UIImage imageNamed:@"yiem.png"];
    
    img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgAction:)];
    [img addGestureRecognizer:tap];
    [TabVIew addSubview:img];
    
    self.tableView.tableHeaderView = TabVIew;
    
 
    
    
    // 隐藏 剩余的TableViewCell  线条
    UIView *view = [[UIView alloc] init];

    _tableView.tableFooterView= view;
    
    
    
}
- (void)tapImgAction:(UITapGestureRecognizer *)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"搜索职位" message:@"请输入如 \n 『iOS开发 上海』 \n 关键词且大于4个字符！ " preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertY = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        

        
        if ([[[alertC textFields] firstObject] text].length >= 4 ) {
//            NSLog(@"0");

            YIem_Three_TabBar_ViewController *vi = [[YIem_Three_TabBar_ViewController alloc] init];
            [vi setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vi];
            vi.str = [[[alertC textFields] firstObject] text];
            [self presentViewController:nc animated:YES completion:nil];
            
        }else {
//            NSLog(@"1");
        }
        
        
    }];
    // 添加文本输入框
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入职位以及城市";
        
        
    }];
    
    [alertC addAction:alertY];
    [self presentViewController:alertC animated:YES completion:nil];

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"%ld", indexPath.row);
    if (0 == indexPath.row) {
        
        self.alert = [UIAlertController alertControllerWithTitle:@"修改职位信息" message:@"请务必输入真实信息" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            
            // 判断是走默认地方还是 用户输入
            if ([[[self.alert textFields]firstObject]text].length > 0) {
                [self.userDataBaseInfo setObject:[[[self.alert textFields] firstObject] text] forKey:@"job"];
            }else {
//                [self.userDataBaseInfo setObject:@"iOS" forKey:@"job"];
                
            }
            if ([[[self.alert textFields]lastObject]text].length >= 2) {
                [self.userDataBaseInfo setObject:[[[self.alert textFields] lastObject] text] forKey:@"city"];
                
            }else {
//                [self.userDataBaseInfo setObject:@"上海" forKey:@"city"];
                
            }

            
            
        }];
        
        // 添加文本输入框
        [self.alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入职位";
            
            
        }];
        
        // 添加文本输入框
        [self.alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入城市";
            
        }];
        [self.alert addAction:alertA];
        
    
        
        [self presentViewController:self.alert animated:YES completion:nil];
        
    }else if (1 == indexPath.row) {
        
        
        SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
        storeProductViewContorller.delegate = self;
        [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"1167301342"} completionBlock:^(BOOL result, NSError *error) {
            
            /**
             *  实现代理   SKStoreProductViewControllerDelegate
             */
            // 1167301342 为App id   // 在itunesconnect.apple.com  查看
      
            // 推出 App Store
                [self presentViewController:storeProductViewContorller animated:YES completion:^{
                    
                }];
            
        }];
        
    
    

 
        

    }else if (2 == indexPath.row) {
        

        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"关于职位情报" message:@"职位情报是一个综合的职位搜索大全！\n 也许你的高薪从这里开始！\n 不错的话请推荐给你身边的人！ \n 当然有问题可以给我发邮件！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        [alertC addAction:alertA];
        
        [self presentViewController:alertC animated:YES completion:nil];
 
        
    }else if (3 == indexPath.row) {
        // 打开浏览器
        NSURL *url = [[NSURL alloc] initWithString:@"http://yiem.net"];
        [[UIApplication sharedApplication] openURL:url];

    }else if (4 == indexPath.row) {
        
        // 发邮件
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@yiem.net"]];
        
    }
    
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:^{
    
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

//
//  YIem_One_TabBar_Home_Did_ViewController.m
//  indeed
//
//  Created by YIem on 16/10/14.
//  Copyright © 2016年 YIem. All rights reserved.
//

#import "YIem_One_TabBar_Home_Did_ViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface YIem_One_TabBar_Home_Did_ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *strUrl;
@property (nonatomic, strong) NSString *url;
@end

@implementation YIem_One_TabBar_Home_Did_ViewController

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
- (void)setDataModel:(YIem_One_TabBar_Home_Model *)dataModel {
    _dataModel = dataModel;
    
    self.navigationItem.title = dataModel.jobtitle;
    self.url = dataModel.jobkey;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self dataBaseArr];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = self.titleStr;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    
    
    
    
    [self dataBaseArr];

}

- (void)dataBaseArr {
    
//self.dataBaseArr = [NSMutableArray array ];

    NSString *url = [NSString stringWithFormat:@"http://api.indeed.com/ads/apigetjobs?publisher=9427261241958914&v=2&format=json&jobkeys=%@", self.url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        
        for (NSDictionary *dic in [responseObject objectForKey:@"results"]) {
            
            self.strUrl = [dic objectForKey:@"url"];
        }
        
        [self web];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
//        NSLog(@"请求失败%@", (error));
    }];



}
- (void)web {
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.webView.paginationMode = UIWebPaginationModeUnpaginated;
    NSString *str = self.strUrl;
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:self.webView];
    
    
    

    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requesURL = [request URL];
    if (([[requesURL scheme] isEqualToString:@"http"] || [[requesURL scheme] isEqualToString:@"https"] || [[requesURL scheme] isEqualToString:@"mailto"]) && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        return ![[UIApplication sharedApplication] openURL:requesURL];
        
    }
    return YES;
}

- (void)leftAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
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

//
//  AppDelegate.m
//  indeed
//
//  Created by YIem on 16/10/11.
//  Copyright © 2016年 YIem. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "YIem_One_TabBar_Home_ViewController.h"
#import "YIem_Two_TabBar_Home_ViewController.h"
#import "YIem_Three_TabBar_Home_ViewController.h"
#import "Reachability.h"
@interface AppDelegate ()


@end

@implementation AppDelegate





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReach startNotifier];
    [self updateInterfaceWithReachability:hostReach];
    


//        NSLog(@"不是");
        // window - 大小
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        // window - 背景颜色
        self.window.backgroundColor = [UIColor whiteColor];
        // window - 为主视图
        [self.window makeKeyAndVisible];
        
        // VC 数组
        NSArray *classArray = @[@"YIem_One_TabBar_Home_ViewController", @"YIem_Two_TabBar_Home_ViewController", @"YIem_Three_TabBar_Home_ViewController"];
        // Title 数组
        NSArray *titleArray = @[@"- 推荐 -", @"- ⊙▂⊙ -", @"- 设置 -"];
        // Photo 数组 未选中
        NSArray *photoArray = @[@"one_2.png", @"two_2.png", @"three_2.png"];
        // Photo 数组 选中
        NSArray *photoSelectedArray = @[@"one_1.png", @"two_1.png", @"three_1.png"];
        // Bar 数组
        NSMutableArray *tabBarArr = [NSMutableArray array];
        // 循环输出 Bar
        for (NSInteger i = 0; i < titleArray.count; i++) {
            Class v = NSClassFromString(classArray[i]);
            UIViewController *vc = [[[v class] alloc] init];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:[[UIImage imageNamed:photoArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:photoSelectedArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [nc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.0 green:0.3264 blue:0.2772 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
            [tabBarArr addObject:nc];
            
            
        }
        // 创建 Bar 视图
        UITabBarController *tabVC = [[UITabBarController alloc] init];
        tabVC.viewControllers = tabBarArr;
        
        // 添加
        self.window.rootViewController = tabVC;
        


    
    
    return YES;
}


//在程序的启动处，开启通知

// 连接改变

- (void)reachabilityChanged: (NSNotification*)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
//处理连接改变后的情况

- (void)updateInterfaceWithReachability: (Reachability*)curReach
{
    //对连接改变做出响应的处理动作。
    
    NetworkStatus status=[curReach currentReachabilityStatus];
    
    if (status== NotReachable) { //没有连接到网络就弹出提实况
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网路异常" message:@"请检查网路连接" preferredStyle:UIAlertControllerStyleAlert];
        [self.window.rootViewController presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

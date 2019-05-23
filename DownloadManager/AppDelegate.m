//
//  AppDelegate.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/8.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TwoViewController.h"
#import "DownloadedController.h"
#import "HJDownLoadManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[HJDownLoadManager sharedManager] unArchiveData];
    
    // 将引导页设置为跟视图控制器
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        
    ViewController *vc = [[ViewController alloc]init];
    UINavigationController *naVc = [[UINavigationController alloc]initWithRootViewController:vc];
    naVc.tabBarItem.title = @"显示";

    TwoViewController *twoVc = [[TwoViewController alloc]init];
    UINavigationController *tNavc = [[UINavigationController alloc]initWithRootViewController:twoVc];
    tNavc.tabBarItem.title = @"下载中";
    
    DownloadedController *downloadedVc = [[DownloadedController alloc]init];
    UINavigationController *downloadedNavc = [[UINavigationController alloc]initWithRootViewController:downloadedVc];
    downloadedVc.title = @"已下载";
    
    UITabBarController *tabVc = [[UITabBarController alloc]init];
    tabVc.viewControllers = @[naVc,tNavc,downloadedNavc];
    
    self.window.rootViewController = tabVc;
    
    NSLog(@"%@",NSHomeDirectory());

    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s",__func__);
    [HJDownLoadManager sharedManager].backgroundSessionCompletionHandler = completionHandler;
}

#pragma mark - 程序进入非活跃状态  黑屏或者打电话的时候
- (void)applicationWillResignActive:(UIApplication *)application {
//    NSLog(@"%s",__func__);
    [[HJDownLoadManager sharedManager] archiveData];
}

#pragma mark - 程序进入活跃状态
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    NSLog(@"%s",__func__);
}

#pragma mark - 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
//    NSLog(@"%s",__func__);
}

#pragma mark - 程序进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
//    NSLog(@"%s",__func__);
}





- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
    
    [[HJDownLoadManager sharedManager] archiveData];
}

+ (AppDelegate*)sharedInstance {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}@end

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

    [[HJDownLoadManager sharedManager]  continueDownload];

    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    [HJDownLoadManager sharedManager].backgroundSessionCompletionHandler = completionHandler;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    NSLog(@"%s",__func__);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSLog(@"%s",__func__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    NSLog(@"%s",__func__);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    NSLog(@"%s",__func__);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    NSLog(@"%s",__func__);
}

+ (AppDelegate*)sharedInstance {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}@end

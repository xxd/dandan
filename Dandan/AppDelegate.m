//
//  AppDelegate.m
//  Dandan
//
//  Created by 陈 振宇 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 修改状态栏为黑色透明背景
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    // 修改NavigationBar的背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"BackgroundTopbar"] forBarMetrics:UIBarMetricsDefault];
    
    
    // 修改后退按钮的背景
    // 普通模式
    UIImage *uiBarBackButtonNormal = [[UIImage imageNamed:@"uiBarBackButtonNormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:uiBarBackButtonNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // 选中模式
    UIImage *uiBarBackButtonSelected = [[UIImage imageNamed:@"uiBarBackButtonSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:uiBarBackButtonSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    // 修改常规按钮的背景
    // 普通模式
    UIImage *uiBarButtonItemNormal = [[UIImage imageNamed:@"uiBarButtonItemNormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:uiBarButtonItemNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // 选中模式
    UIImage *uiBarButtonItemSelected = [[UIImage imageNamed:@"uiBarButtonItemSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:uiBarButtonItemSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

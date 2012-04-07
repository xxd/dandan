//
//  AppDelegate.m
//  Dandan
//
//  Created by 陈 振宇 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Sync.h"

@interface AppDelegate(Private)
-(void)createEditableCopyofDatabaseIfNeeded;
-(void)initializeDatabase;
-(void)syncList;
@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize listArray;

-(void)createEditableCopyofDatabaseIfNeeded{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writeableDBPath = [documentsDirectory stringByAppendingPathComponent:@"dan.sqlite"];
    NSLog(@"%@",writeableDBPath);
    success = [fileManager fileExistsAtPath:writeableDBPath];
    if (success) return;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"dan.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writeableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(void)initializeDatabase{    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"dan.sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        const char *sql = "SELECT id FROM lists ORDER BY id DESC LIMIT 1";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSInteger primaryKey = sqlite3_column_int(statement, 0);
                if (!primaryKey) return;
                Sync *sync = [[Sync alloc] syncWithList:primaryKey];
                listArray = [sync copy];
            }
        } else {
            Sync *sync = [[Sync alloc] syncWithList:0];
            listArray = [sync copy];    
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    NSLog(@"listArray包含：%@",listArray);
    NSLog(@"The content of arry is %i",[listArray count]);  
}

-(void)syncList{
    NSDictionary *listDict;
    char *errorMsg; 
    NSInteger listID;
    NSString *listTitle;
    NSInteger categoryID;
    
    for(int i = 0; i < [listArray count]; i++){		
		listDict = [listArray objectAtIndex:i];
        for (id key in listDict) {
            NSLog(@"key:%@, value:%@",key,[listDict objectForKey:key]);
        }
        listID = [listDict objectForKey:@"id"];
        listTitle = [listDict objectForKey:@"title"];
        categoryID = [listDict objectForKey:@"category_id"];
        NSString *insertSQL = [NSString stringWithFormat: @"insert into lists (id,title,category_id) values(\"%@\", \"%@\", \"%@\")", listID, listTitle,categoryID];
        NSLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        if (sqlite3_exec(database, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) { 
            NSLog(@"insert ok.");
        }
	}	
}

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

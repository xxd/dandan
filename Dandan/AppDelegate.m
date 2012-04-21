//
//  AppDelegate.m
//  Dandan
//
//  Created by 陈 振宇 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Sync.h"
#import "LocalSQLiteOperate.h"

@interface AppDelegate(Private)
-(void)createEditableCopyofDatabaseIfNeeded;
-(void)tableExist;
-(void)initializeDatabase;
-(void)syncList;
-(void)syncCategorie;
@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize listArray;


static sqlite3_stmt *statementChk = nil;

//+(NSString *)sharedInstance
//{
//    NSString *SQLiteFilename = @"dan.sqlite";
//    return SQLiteFilename;
//}

-(void)createEditableCopyofDatabaseIfNeeded{
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
	if(success) return;
//    NSString * sQLiteFilename = [AppDelegate sharedInstance];
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLiteFilename];
    NSError *error;
	success = [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(void)tableExist{
    
    sqlite3_prepare_v2(database, "SELECT name FROM sqlite_master WHERE type='table' AND name='lists';", -1, &statementChk, nil);
    bool boo = FALSE;
    if (sqlite3_step(statementChk) == SQLITE_ROW) {
        boo = TRUE;
        NSLog(@"exist!");
    } else {
        char *errorMsg;
        const char *createSQL = "create table if not exists lists(id INTEGER, title VARCHAR(255), category_id INTEGER,last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
        if (sqlite3_exec(database, createSQL, NULL, NULL, &errorMsg)==SQLITE_OK) { 
            NSLog(@"create ok."); 
        }
    }
    sqlite3_finalize(statementChk);
}

-(void)initializeDatabase{    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSArray *tableArray = [NSArray arrayWithObjects:@"List", @"Categorie", nil];
        for ( NSString *table in tableArray ){
            NSLog( @"table name:%@", table);
            SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"syncWith%@:", table]);
            //NSLog( @"customSelector:%@", customSelector);
            SEL syncToLiteSel = NSSelectorFromString([NSString stringWithFormat:@"sync%@", table]);
            //NSLog( @"syncToLiteSel:%@", syncToLiteSel);
            NSString *sql_str = [NSString stringWithFormat:@"SELECT id FROM %@s ORDER BY id DESC LIMIT 1", table];
            const char *sql = (char *)[sql_str UTF8String];
            NSLog( @"SQL :%@", sql_str);
            sqlite3_stmt *statement;
            Sync * sync = [Sync alloc];
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    int primaryKey = sqlite3_column_int(statement, 0);
                    NSLog(@"primaryKey：%i",primaryKey);
                    if ([[Sync alloc] respondsToSelector:customSelector]) {
                        sync = [[Sync alloc] performSelector:customSelector withObject:[NSNumber numberWithInt:primaryKey]];
                        listArray = [sync copy];
                        if ([self respondsToSelector:syncToLiteSel]) 
                        {
                            [self performSelector:syncToLiteSel];
                        } else {
                            NSLog(@"## Class does not respond to %s", syncToLiteSel);
                        }
                    } else {
                        NSLog(@"## Class does not respond to %s", customSelector);
                    }
                } else {
                    if ([[Sync alloc] respondsToSelector:customSelector]) {
                        sync = [[Sync alloc] performSelector:customSelector withObject:0];
                        listArray = [sync copy];
                        if ([self respondsToSelector:syncToLiteSel]) 
                        {
                            [self performSelector:syncToLiteSel];
                        } else {
                            NSLog(@"## Class does not respond to %s", syncToLiteSel);
                        }
                    } else {
                        NSLog(@"## Class does not respond to %s", customSelector);
                    }
                }
            }
            sqlite3_finalize(statement);
            //NSLog(@"listArray包含：%@",listArray);
            NSLog(@"The content of arry is %i",[listArray count]); 
        }
    }else{
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
}

-(void)syncList{
    NSDictionary *listDict;
    char *errorMsg; 
    NSNumber *listID;
    NSString *listTitle;
    NSNumber *categoryID;
    
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

-(void)syncCategorie{
    NSDictionary *categoryDict;
    char *errorMsg; 
    NSInteger categoryID;
    NSString *categoryName;
    
    for(int i = 0; i < [listArray count]; i++){		
		categoryDict = [listArray objectAtIndex:i];
        for (id key in categoryDict) {
            NSLog(@"key:%@, value:%@",key,[categoryDict objectForKey:key]);
        }
        categoryID = [categoryDict objectForKey:@"id"];
        categoryName = [categoryDict objectForKey:@"name"];
        NSString *insertSQL = [NSString stringWithFormat: @"insert into categories (id,name) values(\"%@\", \"%@\")", categoryID, categoryName];
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
    
    // SQLite的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    databasePath = [documentsDirectory stringByAppendingPathComponent:SQLiteFilename];
    
    // 创建SQLite数据库
    [self createEditableCopyofDatabaseIfNeeded];
    // 同步表
    
    [self initializeDatabase];

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

//
//  AppDelegate.h
//  Dandan
//
//  Created by 陈 振宇 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define SQLiteFilename    @"dan.sqlite"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    sqlite3 *database;
    NSMutableArray *listArray;
    NSString *databasePath;
}
@property (strong, nonatomic) NSMutableArray *listArray;

@property (strong, nonatomic) UIWindow *window;

@end

//
//  AppDelegate.h
//  Dandan
//
//  Created by 陈 振宇 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    sqlite3 *database;
    NSMutableArray *listArray;
}
@property (strong, nonatomic) NSMutableArray *listArray;

@property (strong, nonatomic) UIWindow *window;

@end

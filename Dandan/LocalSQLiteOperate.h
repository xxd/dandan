//
//  LocalSQLiteOperate.h
//  Dandan
//
//  Created by xxd on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface LocalSQLiteOperate : NSObject{
    sqlite3 *database;
}
- (NSString *) getDBPath;
- (NSInteger)CreateNewList:(sqlite3 *)db listTitle:(NSString *)listTitle categoryID:(NSInteger *)categoryID isShare:(BOOL)isShare;
- (NSArray *)getCategoryList;
- (NSArray *)getList;
- (NSInteger)insertNewTodoIntoDatabase;

@end

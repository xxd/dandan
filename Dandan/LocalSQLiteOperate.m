//
//  LocalSQLiteOperate.m
//  Dandan
//
//  Created by xxd on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalSQLiteOperate.h"

static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *selectstmt = nil;

@implementation LocalSQLiteOperate
//获取数据库路径
- (NSString *) getDBPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"dan.sqlite"];
}

//建立新列表list
- (NSInteger)CreateNewList:(sqlite3 *)db listTitle:(NSString *)listTitle categoryID:(NSInteger *)categoryID isShare:(BOOL)isShare{
    if (sqlite3_open([self.getDBPath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"path:%@",self.getDBPath);

    if (insert_statement == nil) {
//        int category_ID = [categoryID intValue];
        int share = (isShare==true)? 1:0;
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO `lists` (`title`, `category_id`, `isShare`) VALUES (\"%@\", \"%i\", \"%i\")", listTitle,categoryID,share];
        const char *sql = [insertSQL UTF8String];
        NSLog(@"Insert SQL: %s",sql);
        if (sqlite3_prepare_v2(db, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    int success = sqlite3_step(insert_statement);
    
    sqlite3_reset(insert_statement);
    if (success != SQLITE_ERROR) {
        return sqlite3_last_insert_rowid(db);
    }
    NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
    return -1;
    }
}

//获取Category列表
- (NSArray *)getCategoryList
{
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT name FROM categories";
        NSMutableArray *categroyNameArray = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(selectstmt) == SQLITE_ROW) {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                [categroyNameArray addObject:name];
                
                
            }
            return categroyNameArray;
        }
        sqlite3_finalize(selectstmt);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}


//获取Category列表
- (NSArray *)getList
{
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT title FROM lists";
        NSMutableArray *categroyNameArray = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(selectstmt) == SQLITE_ROW) {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                [categroyNameArray addObject:name];
                
                
            }
            return categroyNameArray;
        }
        sqlite3_finalize(selectstmt);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}

//调试用 Debug Only!

-(void)mungeFirst:(NSString**)stringOne andSecond:(NSString**)stringTwo
{
    *stringOne = [NSString stringWithString:@"foo"];
    *stringTwo = [NSString stringWithString:@"baz"];
}

@end

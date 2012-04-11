//
//  LocalSQLiteOperate.m
//  Dandan
//
//  Created by xxd on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalSQLiteOperate.h"
static sqlite3_stmt *insert_statement = nil;

@implementation LocalSQLiteOperate

- (NSString *) getDBPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"dan.sqlite"];
}

- (NSInteger)CreateNewList:(sqlite3 *)db listID:(NSNumber *)listID  listTitle:(NSString *)listTitle categoryID:(NSNumber *)categoryID{
    if (sqlite3_open([self.getDBPath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"path:%@",self.getDBPath);

    if (insert_statement == nil) {
        int list_ID = [listID intValue];
        int category_ID = [categoryID intValue];
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO `lists` (`id`, `title`, `category_id`) VALUES (\"%i\", \"%@\", \"%i\")", list_ID, listTitle, category_ID];
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


- (NSInteger)insertNewTodoIntoDatabase {
    
    if (insert_statement == nil) {
    //database = db;
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO `lists` (`id`, `title`, `category_id`) VALUES(7,'test7',7)"];
    const char *sql = [insertSQL UTF8String];
    NSLog(@"Insert SQL: %s",sql);
    if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
}
int success = sqlite3_step(insert_statement);

sqlite3_reset(insert_statement);
if (success != SQLITE_ERROR) {
    return sqlite3_last_insert_rowid(database);
}
NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
return -1;

}


@end

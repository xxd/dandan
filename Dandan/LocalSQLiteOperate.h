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
- (NSInteger)CreateNewList:(sqlite3 *)db listID:(NSNumber *)listID  listTitle:(NSString *)listTitle categoryID:(NSNumber *)categoryID;
-(NSInteger)insertNewTodoIntoDatabase;

@end

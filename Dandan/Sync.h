//
//  Sync.h
//  Dandan
//
//  Created by xxd on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Sync;
@protocol syncDelegate <NSObject>
-(void)controller:(Sync *)controller syncWithList:(NSInteger)listID;
@end

@interface Sync : NSObject{
    sqlite3 *database;
    NSDictionary *dictCategory;
    NSArray *listData;
    NSInteger *listsID;
}

@property (nonatomic,retain) NSArray *listData;
@property (nonatomic) NSInteger *listsID;
@property (nonatomic, weak) id <syncDelegate> delegate;

-(NSArray *)syncWithList:(NSInteger)listID;
-(NSArray *)syncWithCategorie:(NSNumber *)categoryID;
-(id)initWithPrimaryKey:(NSInteger)pk;
@end

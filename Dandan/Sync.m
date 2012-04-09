//
//  Sync.m
//  Dandan
//
//  Created by xxd on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Sync.h"

#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DictionaryHelper.h"

@implementation Sync

@synthesize listData,delegate,listsID;

-(NSArray *)syncWithList:(NSNumber *)listID
{
    int primaryKey = [listID intValue];
    NSLog(@"%i", primaryKey);
    NSString *urlit = [NSString stringWithFormat:@"http://0.0.0.0:3000/lists/%i/sync.json?auth_token=%@",primaryKey,@"gseSYCEtQsqtTXyiDRwa"];
    NSLog(@"url: %@",urlit);
    NSURL *freequestionurl = [NSURL URLWithString:urlit];
    ASIHTTPRequest *back = [ASIHTTPRequest requestWithURL:freequestionurl];
    [back startSynchronous];
    listData = [[back responseString] objectFromJSONString];
    NSLog(@"listData: %@",listData);
    return listData;
}

-(id)initWithPrimaryKey:(NSInteger)pk{
    NSInteger primaryKey;
    primaryKey = pk;
    return self;
}

@end

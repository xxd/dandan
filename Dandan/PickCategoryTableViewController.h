//
//  PickCategoryTableViewController.h
//  Dandan
//
//  Created by  on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class PickCategoryTableViewController;
@protocol pickCategoryTableViewControllerDelegate <NSObject>
-(void)controller:(PickCategoryTableViewController *)controller didSelectCategory:(NSString *)category;
@end

@interface PickCategoryTableViewController : UITableViewController{
    sqlite3   *database;
}
@property (strong, nonatomic) NSArray *categories;
@property (nonatomic, weak) id <pickCategoryTableViewControllerDelegate> delegate;
@end

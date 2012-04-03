//
//  PickCategoryTableViewController.h
//  Dandan
//
//  Created by  on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickCategoryTableViewController;
@protocol pickCategoryTableViewControllerDelegate <NSObject>
-(void)controller:(PickCategoryTableViewController *)controller didSelectCategory:(NSString *)category;
@end

@interface PickCategoryTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *categories;
@property (nonatomic, weak) id <pickCategoryTableViewControllerDelegate> delegate;
@end

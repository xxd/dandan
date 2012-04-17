//
//  NewListTableViewController.h
//  Dandan
//
//  Created by 陈 振宇 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PickCategoryTableViewController.h"

@interface NewListTableViewController : UITableViewController
<UITextFieldDelegate, pickCategoryTableViewControllerDelegate>{
    sqlite3 *database;
    NSInteger categoryIndexID;
    NSString *categoryName;
}

@property (strong, nonatomic) UITextField *listNameTextField;
@property (strong, nonatomic) UISwitch *isShare;
@property (nonatomic) NSInteger categoryIndexID;
@property (strong, nonatomic) NSString *categoryName;

- (IBAction)CancelModal:(id)sender;
- (IBAction)CreateList:(id)sender;
@end

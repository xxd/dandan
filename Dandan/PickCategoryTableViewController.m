//
//  PickCategoryTableViewController.m
//  Dandan
//
//  Created by  on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PickCategoryTableViewController.h"
#import "LocalSQLiteOperate.h"
#import "NewListTableViewController.h"

@interface PickCategoryTableViewController ()

@end

@implementation PickCategoryTableViewController
@synthesize delegate, categories;

- (NSArray *)fillCategoryList{
    if ([[LocalSQLiteOperate alloc]  respondsToSelector:@selector(getCategoryList)]) 
    {
        categories = [[LocalSQLiteOperate alloc]  performSelector:@selector(getCategoryList)];
    } else {
        NSLog(@"## Class does not respond to getCategoryList");
    }
    
    return categories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillCategoryList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categories count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger row = [indexPath row];
    cell.textLabel.text = [categories objectAtIndex:row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate controller:self didSelectCategory:[categories objectAtIndex:[indexPath row]]];
    NewListTableViewController *newListTableViewController = [[NewListTableViewController alloc]init];
    newListTableViewController.categoryIndexID = [indexPath row];
    NSLog(@"categoryIndexID:%i",newListTableViewController.categoryIndexID);
    [self.navigationController popViewControllerAnimated:YES];
}

@end

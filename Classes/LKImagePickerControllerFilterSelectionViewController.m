//
//  LKImagePickerControllerFilterSelectionViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerFilterSelectionViewController.h"
#import "LKImagePickerControllerFilter.h"
#import "LKImagePickerControllerSelectViewController.h"
@interface LKImagePickerControllerFilterSelectionViewController ()

@end

@implementation LKImagePickerControllerFilterSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"FilterCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsManager.filter.numberOfTypes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
    
    LKImagePickerControllerFilterType type = [self.assetsManager.filter typeAtIndex:indexPath.row];
    cell.textLabel.text = [self.assetsManager.filter descriptionFotType:type];
    cell.accessoryType = self.assetsManager.filter.type == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.assetsManager.filter.type = indexPath.row;
    [self.selectViewController didChangeFilterType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

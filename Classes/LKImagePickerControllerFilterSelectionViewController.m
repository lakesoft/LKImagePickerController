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
#import "LKImagePickerControllerBundleManager.h"

@interface LKImagePickerControllerFilterSelectionViewController ()
@property (nonatomic, assign) LKImagePickerControllerFilterType firstType;
@end

@implementation LKImagePickerControllerFilterSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"FilterScreen.Title"];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"FilterCell"];
    
    self.firstType = self.assetsManager.filter.type;
    NSLog(@"%zd", self.firstType);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsManager.filter.filterTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
    
    LKImagePickerControllerFilterType type = [self.assetsManager.filter typeAtIndex:indexPath.row];
    cell.textLabel.text = [self.assetsManager.filter descriptionFotType:type];
    cell.accessoryType = self.assetsManager.filter.type == type ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKImagePickerControllerFilterType filterType = [self.assetsManager.filter typeAtIndex:indexPath.row];
    self.assetsManager.filter.type = filterType;
    if (filterType != self.firstType) {
        [self.selectViewController didChangeFilterType];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

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
#import "LKImagePickerControllerAppearance.h"

@interface LKImagePickerControllerFilterSelectionViewController ()
@property (nonatomic, assign) LKImagePickerControllerFilterType firstType;
@end

@implementation LKImagePickerControllerFilterSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = LKImagePickerControllerAppearance.sharedAppearance.navigationBarColor;
    self.navigationController.navigationBar.tintColor = LKImagePickerControllerAppearance.sharedAppearance.navigationFontColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: LKImagePickerControllerAppearance.sharedAppearance.navigationFontColor};

    
    self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"FilterScreen.Title"];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"FilterCell"];
    self.tableView.tintColor = LKImagePickerControllerAppearance.sharedAppearance.checkBackgroundColor;
    
    self.firstType = self.assetsManager.filter.currentType;
//    NSLog(@"%zd", self.firstType);
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
    cell.textLabel.text = [self.assetsManager.filter descriptionForType:type];
    cell.accessoryType = self.assetsManager.filter.currentType == type ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKImagePickerControllerFilterType filterType = [self.assetsManager.filter typeAtIndex:indexPath.row];
    self.assetsManager.filter.currentType = filterType;
    if (filterType != self.firstType) {
        [self.selectViewController didChangeFilterType];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

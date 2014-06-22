//
//  LKImagePickerControllerGroupTableViewController.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2014/06/12.
//
//

#import "LKImagePickerControllerGroupTableViewController.h"
#import "LKAssetsLibrary.h"
#import "LKImagePickerControllerSelectViewController.h"

@implementation LKImagePickerControllerGroupTableViewController


#pragma mark - Basics
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"GroupCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsLibrary.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    LKAssetsGroup* assetsGroup = self.assetsLibrary.assetsGroups[indexPath.row];
    
    cell.imageView.image = assetsGroup.posterImage;
    cell.textLabel.text = assetsGroup.description;
    
    if ([self.assetsGroup isEqual:assetsGroup]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKAssetsGroup* assetsGroup = self.assetsLibrary.assetsGroups[indexPath.row];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.selectViewController didSelectAssetsGroup:assetsGroup];
}



@end

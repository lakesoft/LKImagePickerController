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

    self.title = NSLocalizedString(@"Groups", nil);
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"GroupCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbar.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsManager.assetsLibrary.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    LKAssetsGroup* assetsGroup = self.assetsManager.assetsLibrary.assetsGroups[indexPath.row];
    
    cell.imageView.image = assetsGroup.posterImage;
    cell.textLabel.text = assetsGroup.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", assetsGroup.assets.count];
    
    if ([self.assetsManager.assetsGroup isEqual:assetsGroup]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKAssetsGroup* assetsGroup = self.assetsManager.assetsLibrary.assetsGroups[indexPath.row];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.selectViewController didSelectAssetsGroup:assetsGroup];
}



@end

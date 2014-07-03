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
#import "LKImagePickerControllerBundleManager.h"
#import "LKImagePickerControllerGroupTableViewCell.h"

@implementation LKImagePickerControllerGroupTableViewController


#pragma mark - Basics
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"Assets.Groups"];
    UINib* nib = [UINib nibWithNibName:@"LKImagePickerControllerGroupTableViewCell" bundle:LKImagePickerControllerBundleManager.bundle];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"LKImagePickerControllerGroupTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsManager.assetsLibrary.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKImagePickerControllerGroupTableViewCell* cell = (LKImagePickerControllerGroupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LKImagePickerControllerGroupTableViewCell" forIndexPath:indexPath];
    cell.assetsGroup = self.assetsManager.assetsLibrary.assetsGroups[indexPath.row];
    
//    cell.imageView.image = assetsGroup.posterImage;
//    cell.textLabel.text = assetsGroup.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", assetsGroup.assets.count];
    
    if ([self.assetsManager.assetsGroup isEqual:cell.assetsGroup]) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LKImagePickerControllerGroupTableViewControllerCellHeight;
}


@end

//
//  LKImagePickerControllerGroupTableViewController.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2014/06/12.
//
//

#import "LKImagePickerControllerGroupTableViewController.h"
#import <LKAssetsLibrary/LKAssetsLibrary.h>
#import "LKImagePickerControllerSelectViewController.h"
#import "LKImagePickerControllerBundleManager.h"
#import "LKImagePickerControllerGroupTableViewCell.h"
#import "LKImagePickerControllerAppearance.h"

@interface LKImagePickerControllerGroupTableViewController()
@property (nonatomic, assign) BOOL didLayoutSubviews;
@end

@implementation LKImagePickerControllerGroupTableViewController

#pragma mark - Privates
- (void)_scrollAnimated:(BOOL)animated
{
    NSInteger index=0;
    for (; index < self.assetsManager.assetsLibrary.assetsGroups.count; index++) {
        LKAssetsGroup* assetGroup = self.assetsManager.assetsLibrary.assetsGroups[index];
        if ([self.assetsManager.assetsGroup isEqual:assetGroup]) {
            break;
        }
    }
    if (index < self.assetsManager.assetsLibrary.assetsGroups.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:animated];
    }
}

#pragma mark - Basics
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"Assets.Groups"];
    UINib* nib = [UINib nibWithNibName:@"LKImagePickerControllerGroupTableViewCell" bundle:LKImagePickerControllerBundleManager.bundle];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"LKImagePickerControllerGroupTableViewCell"];
    
    self.tableView.tintColor = LKImagePickerControllerAppearance.sharedAppearance.tintColor;

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!self.didLayoutSubviews) {
        [self _scrollAnimated:NO];
        self.didLayoutSubviews = YES;
    }
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
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.selectViewController didSelectAssetsGroup:assetsGroup];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LKImagePickerControllerGroupTableViewControllerCellHeight;
}


@end

//
//  LKImagePickerControllerGroupTableViewController.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2014/06/12.
//
//

#import "LKImagePickerControllerGroupTableViewController.h"
#import "LKAssetsLibrary.h"

@interface LKImagePickerControllerGroupTableViewController ()
@property (strong, nonatomic) LKAssetsLibrary* assetsLibrary;
@end

@implementation LKImagePickerControllerGroupTableViewController

#pragma mark - Privates
- (void)_assetsLibraryDidSetup:(NSNotification*)notification
{
    [self.tableView reloadData];
}

- (void)_assetsLibraryDidInsertGroup:(NSNotification*)notification
{
    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
    NSLog(@"%s|inserted: %@", __PRETTY_FUNCTION__, groups);
    [self.tableView reloadData];
}

- (void)_assetsLibraryDidUpdateGroup:(NSNotification*)notification
{
    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
    NSLog(@"%s|updated: %@", __PRETTY_FUNCTION__, groups);
    [self.tableView reloadData];
}

- (void)_assetsLibraryDidDeleteGroup:(NSNotification*)notification
{
    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
    NSLog(@"%s|deleted: %@", __PRETTY_FUNCTION__, groups);
    [self.tableView reloadData];
}


#pragma mark - Basics
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"GroupCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsLibraryDidSetup:)
                                                 name:LKAssetsLibraryDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsLibraryDidInsertGroup:)
                                                 name:LKAssetsLibraryDidInsertGroupsNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsLibraryDidUpdateGroup:)
                                                 name:LKAssetsLibraryDidUpdateGroupsNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsLibraryDidDeleteGroup:)
                                                 name:LKAssetsLibraryDidDeleteGroupsNotification
                                               object:nil];
    
    
    self.assetsLibrary = [LKAssetsLibrary assetsLibrary];
    [self.assetsLibrary reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

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
    return cell;
}

@end

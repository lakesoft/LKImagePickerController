//
//  LKImagePickerController.m
//  TEST
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerController.h"
#import "LKAssetsLibrary.h"
#import "LKImagePickerControllerAppearance.h"
#import "LKImagePickerControllerGroupTableViewController.h"
#import "LKImagePickerControllerSelectViewController.h"

@interface LKImagePickerController ()
@property (strong, nonatomic) LKAssetsLibrary* assetsLibrary;
@end

@implementation LKImagePickerController

#pragma mark - Privates
- (void)_assetsLibraryDidSetup:(NSNotification*)notification
{
    LKImagePickerControllerSelectViewController* viewController = LKImagePickerControllerSelectViewController.new;
    viewController.assetsLibrary = self.assetsLibrary;
    viewController.assetsGroup = self.assetsLibrary.assetsGroups[0];
    [self pushViewController:viewController animated:NO];
}

- (void)_assetsLibraryDidInsertGroup:(NSNotification*)notification
{
//    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
//    NSLog(@"%s|inserted: %@", __PRETTY_FUNCTION__, groups);
}

- (void)_assetsLibraryDidUpdateGroup:(NSNotification*)notification
{
//    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
//    NSLog(@"%s|updated: %@", __PRETTY_FUNCTION__, groups);
}

- (void)_assetsLibraryDidDeleteGroup:(NSNotification*)notification
{
//    NSArray* groups = notification.userInfo[LKAssetsLibraryGroupsKey];
//    NSLog(@"%s|deleted: %@", __PRETTY_FUNCTION__, groups);
}


#pragma mark - Basics

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications
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


- (void)setCheckmarkForegroundColor:(UIColor *)checkmarkForegroundColor
{
    LKImagePickerControllerAppearance.sharedAppearance.checkmarkForegroundColor = checkmarkForegroundColor;
}
- (void)setCheckmarkBackgroundColor:(UIColor *)checkmarkBackgroundColor
{
    LKImagePickerControllerAppearance.sharedAppearance.checkmarkBackgroundColor = checkmarkBackgroundColor;
}


@end

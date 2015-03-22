//
//  LKImagePickerController.m
//  TEST
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerController.h"
#import "LKImagePickerControllerAssetsManager.h"
#import "LKImagePickerControllerAppearance.h"
#import "LKImagePickerControllerGroupTableViewController.h"
#import "LKImagePickerControllerSelectViewController.h"

@interface LKImagePickerController ()
@property (strong, nonatomic) LKImagePickerControllerAssetsManager* assetsManager;
@property (weak  , nonatomic) LKImagePickerControllerSelectViewController* selectViewController;
@end

@implementation LKImagePickerController

#pragma mark - Privates


#pragma mark - Basics

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UINavigationBar appearance].barTintColor = LKImagePickerControllerAppearance.sharedAppearance.navigationBarColor;
    [UINavigationBar appearance].tintColor = LKImagePickerControllerAppearance.sharedAppearance.foregroundColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.assetsManager = LKImagePickerControllerAssetsManager.assetsManager;
    self.assetsManager.imagePickerController = self;
    [self.assetsManager reloadAssetsWithCompletion:^{
        LKImagePickerControllerSelectViewController* viewController = LKImagePickerControllerSelectViewController.new;
        viewController.imagePickerController = self;
        viewController.assetsManager = self.assetsManager;
        [self pushViewController:viewController animated:NO];
        self.selectViewController = viewController;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    LKImagePickerControllerAppearance.sharedAppearance.tintColor = tintColor;
}

- (void)setMaximumOfSelections:(NSInteger)maximumOfSelections
{
    _maximumOfSelections = maximumOfSelections;
    self.assetsManager.maximumOfSelections = maximumOfSelections;
}

- (void)deselectAll
{
    [self.selectViewController deselectAll];
}

- (void)displayMainScreenAnimated:(BOOL)animated
{
    [self.selectViewController displayMainScreenAnimated:animated];
    [self popToRootViewControllerAnimated:animated];
}

- (NSArray*)selectedAssets
{
    return self.assetsManager.arrayOfSelectedAssets;
}

@end

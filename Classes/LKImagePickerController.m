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
    
    self.assetsManager = LKImagePickerControllerAssetsManager.assetsManager;
    [self.assetsManager reloadAssetsWithCompletion:^{
        LKImagePickerControllerSelectViewController* viewController = LKImagePickerControllerSelectViewController.new;
        viewController.assetsManager = self.assetsManager;
        [self pushViewController:viewController animated:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)setTintColor:(UIColor *)tintColor
{
    LKImagePickerControllerAppearance.sharedAppearance.tintColor = tintColor;
}


@end

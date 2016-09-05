//
//  ViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "ViewController.h"
#import "LKImagePickerController.h"
#import "LKImagePickerControllerAppearance.h"
#import "LKAsset.h"

@interface ViewController () <LKImagePickerControllerDelegate>
@property (nonatomic, strong) LKImagePickerController* controller;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.controller = LKImagePickerController.new;
//    self.controller = [[LKImagePickerController alloc] initWithAvaliableTypes:LKImagePickerControllerFilterTypeAll ^ LKImagePickerControllerFilterTypeVideo currentType:LKImagePickerControllerFilterTypeScreenShot];
    self.controller.imagePickerControllerDelegate = self;
//    self.controller.tintColor = [UIColor colorWithRed:0.078 green:0.67 blue:0.23 alpha:1.000];
//    LKImagePickerControllerAppearance.sharedAppearance.fontColor = UIColor.grayColor;
//    LKImagePickerControllerAppearance.sharedAppearance.toolbarFontColor = UIColor.grayColor;
//    LKImagePickerControllerAppearance.sharedAppearance.tintColor = UIColor.grayColor;
//    LKImagePickerControllerAppearance.sharedAppearance.foregroundColor = UIColor.blueColor;
    self.controller.maximumOfSelections = 20;
    
//    self.controller.navigationBarHidden = YES;
//    self.controller.toolBarHidden = YES;
    
    [self presentViewController:self.controller animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)openPicker:(id)sender {
}

- (void)imagePickerController:(LKImagePickerController *)imagePickerController didFinishWithAssets:(NSArray *)selectedAssets {
    
    for (LKAsset* asset in selectedAssets) {
        NSLog(@"%@", asset.date);
    }
}

//- (NSArray*)rightBarButtonItems {
//    return @[
//             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                           target:self
//                                                           action:@selector(_on3)],
//             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
//                                                           target:self
//                                                           action:@selector(_on3)]
//             ];
//}

//- (UIBarButtonItem*)leftBarButtonItem
//{
//    return nil;
//}
- (void)_on3
{
    [self.controller displayMainScreenAnimated:YES];
}

- (UIBarButtonItem*)rightBarButtonItem3
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                         target:self
                                                         action:@selector(_on3)];
}
- (BOOL)disableRightBarButtonItem3WhenNoSelected
{
    return YES;
}

- (BOOL)canSelectGroups
{
    return YES;
}

//- (BOOL)sortBySelectionOrder
//{
//    return YES;
//}

//- (void)didUpdateSelections:(NSInteger)numberOfSelections
//{
//    NSLog(@"selected: %zd", numberOfSelections);
//}

@end

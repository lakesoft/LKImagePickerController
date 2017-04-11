
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
#import "LKImagePickerControllerBundleManager.h"

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
    
    self.controller.navigationBarHidden = YES;
//    self.controller.toolBarHidden = YES;
//    self.controller.fullScreenDisabled = YES;
    self.controller.doOpenKeyboardInDetailView = YES;

//    [self.controller unmarkAllAssets];

    [self presentViewController:self.controller animated:NO completion:nil];
    
//    [self.controller removeAllComments];
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
    [imagePickerController markSelectedAssets];
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

/*- (void)handleClearSelections:(void (^)())doClear
{
    NSLog(@"X");
    doClear();
}*/

- (void)openFilterMenuWithDescriptions:(NSArray *)descriptions currentIndex:(int)currentIndex completion:(void (^)(int))completion
{
    NSLog(@"%@", descriptions);
    completion(2);
}

- (void)didSelectViewCellLongPressBeganViewController:(UIViewController *)viewController asset:(LKAsset *)asset
{
    NSLog(@"didSelectViewCellLongPressBeganViewController: %@, %@:", viewController, asset);
}

- (void)didDetailViewCellLongPressBeganViewController:(UIViewController *)viewController asset:(LKAsset *)asset
{
    NSLog(@"didDetailViewCellLongPressBeganViewController: %@, %@:", viewController, asset);
}
/*
- (void)didDetailViewThubmailCellLongPressBeganViewController:(UIViewController *)viewController asset:(LKAsset *)asset
{
    NSLog(@"didDetailViewThubmailCellLongPressBeganViewController: %@, %@:", viewController, asset);
}
*/
/*
- (void)setupDetailTopToolbarView:(UIView *)topToolbarView
{
    UINib* nib = [UINib nibWithNibName:@"DetailToolbarView" bundle:nil];
    UIView* view = [nib instantiateWithOwner:self options:nil][0];
    [topToolbarView addSubview:view];
}
*/

// Actions
- (IBAction)onPush:(id)sender {
    NSLog(@"currentAssetOfDetail: %@", self.controller.currentAssetOfDetail);
}

- (void)setupUtilityButton1:(UIButton *)button
{
    UIImage* image = [UIImage imageNamed:@"LKImagePickerController_ButtonUtility" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    [button setImage:image forState:UIControlStateNormal];
}
- (void)onUtilityButton1:(UIButton*)button viewController:(UIViewController*)viewController
{
    [self.controller showInstantMessageInDetail:@"onLeftUtilityButton1"];
}
- (void)setupUtilityButton2:(UIButton *)button
{
    UIImage* image = [UIImage imageNamed:@"LKImagePickerController_ButtonUtility" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    [button setImage:image forState:UIControlStateNormal];
}
- (void)onUtilityButton2:(UIButton*)button viewController:(UIViewController*)viewController
{
    NSLog(@"onLeftUtilityButton2");
}
- (void)setupUtilityButton3:(UIButton *)button
{
    UIImage* image = [UIImage imageNamed:@"LKImagePickerController_ButtonUtility" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    [button setImage:image forState:UIControlStateNormal];
}
- (void)onUtilityButton3:(UIButton*)button viewController:(UIViewController*)viewController
{
    NSLog(@"onLeftUtilityButton3");
}
- (void)setupUtilityButton4:(UIButton *)button
{
    UIImage* image = [UIImage imageNamed:@"LKImagePickerController_ButtonUtility" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    [button setImage:image forState:UIControlStateNormal];
}
- (void)onUtilityButton4:(UIButton*)button viewController:(UIViewController*)viewController
{
    NSLog(@"onLeftUtilityButton4");
}

- (void)didChangeDetailAsset:(LKAsset *)asset viewController:(UIViewController *)viewController
{
    NSLog(@"didChangeDetailAsset: %@", asset);
}

- (void)didGetAssetChangesInDetail
{
    NSLog(@"didGetAssetChangesInDetail");
    [self.controller dismissDetail];
}


@end

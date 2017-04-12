//
//  LKImagePickerControllerDetailViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKAssetsLibrary/LKAssetsLibrary.h>
#import "LKImagePickerControllerSelectViewController.h"

extern NSString * const LKImagePickerControllerDetailViewControllerWillAppearNotification;
extern NSString * const LKImagePickerControllerDetailViewControllerWillDisappearNotification;

@class LKImagePickerControllerAssetsManager;
@interface LKImagePickerControllerDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LKAssetsCollection* assetsCollection;
@property (nonatomic, weak) LKImagePickerControllerAssetsManager* assetsManager;
@property (nonatomic, weak) NSIndexPath* indexPath;
@property (nonatomic, weak, readonly) LKAsset* currentAsset;
@property (nonatomic, weak) LKImagePickerControllerSelectViewController* selectViewController;
@property (nonatomic, assign) BOOL navigatioBarHidden;
@property (nonatomic, assign) BOOL aspectFill;


- (IBAction)checkmarkTouchded:(id)sender event:(UIEvent*)event;
- (void)reloadCurrentAsset;
- (void)setInputModeEnabled:(BOOL)enabled;

- (void)displayOriginalImageInDetailCell:(BOOL)on;
- (BOOL)displayingOriginalImageInDetailCell;

- (void)dismiss;
- (void)showInstantMessage:(NSString*)string color:(UIColor*)color;

@end

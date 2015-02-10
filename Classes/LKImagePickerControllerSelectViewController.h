//
//  LKImagePickerControllerSelectViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImagePickerControllerAssetsManager.h"

@class LKImagePickerController;
@interface LKImagePickerControllerSelectViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LKImagePickerController* imagePickerController;
@property (nonatomic, weak) LKImagePickerControllerAssetsManager* assetsManager;

- (void)didSelectAssetsGroup:(LKAssetsGroup*)assetsGroup;
- (void)setIndexPathsForSelectedItems:(NSArray*)indexPathsForSelectedItems;    // for callback
- (void)didChangeFilterType;    // for callback

- (void)deselectAll;

- (IBAction)checkmarkTouchded:(id)sender event:(UIEvent*)event;

@end

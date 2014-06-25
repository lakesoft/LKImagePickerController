//
//  LKImagePickerControllerSelectViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImagePickerControllerAssetsManager.h"

extern NSString * const LKImagePickerControllerSelectViewControllerDidSelectCellNotification;
extern NSString * const LKImagePickerControllerSelectViewControllerDidDeselectCellNotification;
extern NSString * const LKImagePickerControllerSelectViewControllerDidAllDeselectCellNotification;
extern NSString * const LKImagePickerControllerSelectViewControllerKeyIndexPath;
extern NSString * const LKImagePickerControllerSelectViewControllerKeyAllSelected;


@interface LKImagePickerControllerSelectViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LKImagePickerControllerAssetsManager* assetsManager;

- (void)setIndexPathsForSelectedItems:(NSArray*)indexPathsForSelectedItems;    // for callback (strong?
- (void)didSelectAssetsGroup:(LKAssetsGroup*)assetsGroup;

@end

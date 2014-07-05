//
//  LKImagePickerControllerSelectViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImagePickerControllerAssetsManager.h"

@interface LKImagePickerControllerSelectViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LKImagePickerControllerAssetsManager* assetsManager;

- (void)didSelectAssetsGroup:(LKAssetsGroup*)assetsGroup;
- (void)setIndexPathsForSelectedItems:(NSArray*)indexPathsForSelectedItems;    // for callback
- (void)didChangeFilterType;    // for callback

@end

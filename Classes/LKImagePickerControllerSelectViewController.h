//
//  LKImagePickerControllerSelectViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const LKImagePickerControllerSelectViewControllerDidSelectCellNotification;
extern NSString * const LKImagePickerControllerSelectViewControllerDidDeselectCellNotification;
extern NSString * const LKImagePickerControllerSelectViewControllerKeyIndexPath;
extern NSString * const LKImagePickerControllerSelectViewControllerKeyAllSelected;


@class LKAssetsGroup;
@interface LKImagePickerControllerSelectViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LKAssetsGroup* assetsGroup;

@end

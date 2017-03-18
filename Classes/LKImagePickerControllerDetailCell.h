//
//  LKImagePickerControllerDetailCell.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImagePickerControllerDetailViewController.h"
#import <LKAssetsLibrary/LKAssetsLibrary.h>

extern NSString * const LKImagePickerControllerDetailCellSingleTapNotification;
extern NSString * const LKImagePickerControllerDetailCellLongPressNotification;

@interface LKImagePickerControllerDetailCell : UICollectionViewCell

@property (nonatomic, weak) LKAsset* asset;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL aspectFill;
@property (nonatomic, weak) LKImagePickerControllerDetailViewController* viewController;

- (void)didEndDisplay;
- (void)alert;

@end

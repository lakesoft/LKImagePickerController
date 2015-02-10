//
//  LKImagePickerControllerStandardSelectCell.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"
@class LKImagePickerControllerSelectViewController;
@interface LKImagePickerControllerSelectCell : UICollectionViewCell

@property (nonatomic, weak) LKAsset* asset;
@property (nonatomic, assign) BOOL checked;

- (void)alert;

@end

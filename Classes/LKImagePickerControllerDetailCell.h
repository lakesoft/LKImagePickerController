//
//  LKImagePickerControllerDetailCell.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"

@interface LKImagePickerControllerDetailCell : UICollectionViewCell

@property (nonatomic, weak) LKAsset* asset;

- (void)didEndDisplay;

@end

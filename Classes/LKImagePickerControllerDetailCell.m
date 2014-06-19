//
//  LKImagePickerControllerDetailCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerDetailCell.h"

@interface LKImagePickerControllerDetailCell()
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LKImagePickerControllerDetailCell

- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
    self.imageView.image = asset.fullScreenImage;
}

@end

//
//  LKImagePickerControllerStandardSelectCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerStandardSelectCell.h"
#import "LKImagePickerControllerCheckmarkView.h"

#define LKImagePickerControllerStandardSelectCellOffset 10

@interface LKImagePickerControllerStandardSelectCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerCheckmarkView* checkmarkView;
@end

@implementation LKImagePickerControllerStandardSelectCell


- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
    self.photoImageView.image = self.asset.thumbnail;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    self.checkmarkView.hidden = !selected;
}

@end

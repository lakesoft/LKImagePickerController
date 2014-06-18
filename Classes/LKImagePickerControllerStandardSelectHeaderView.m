//
//  LKImagePickerControllerStandardSelectHeaderView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerStandardSelectHeaderView.h"

@interface LKImagePickerControllerStandardSelectHeaderView()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LKImagePickerControllerStandardSelectHeaderView

- (void)setCollectionEntry:(LKAssetsCollectionEntry *)collectionEntry
{
    _collectionEntry = collectionEntry;
    self.titleLabel.text = collectionEntry.description;
}

@end

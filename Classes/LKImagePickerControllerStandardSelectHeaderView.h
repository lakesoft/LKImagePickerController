//
//  LKImagePickerControllerStandardSelectHeaderView.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"

@interface LKImagePickerControllerStandardSelectHeaderView : UICollectionReusableView

@property (nonatomic, weak) LKAssetsCollectionEntry* collectionEntry;
@property (nonatomic, assign) NSInteger section;

@end

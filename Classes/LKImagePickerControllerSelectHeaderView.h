//
//  LKImagePickerControllerSelectHeaderView.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKAssetsLibrary/LKAssetsLibrary.h>

@interface LKImagePickerControllerSelectHeaderView : UICollectionReusableView

@property (nonatomic, weak) LKAssetsCollectionEntry* collectionEntry;
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) BOOL allSelected;

@end

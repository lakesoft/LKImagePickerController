//
//  LKImagePickerControllerStandardSelectViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKAssetsGroup;
@interface LKImagePickerControllerStandardSelectViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LKAssetsGroup* assetsGroup;

@end

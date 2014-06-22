//
//  LKImagePickerControllerDetailViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"
#import "LKImagePickerControllerSelectViewController.h"

@interface LKImagePickerControllerDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LKAssetsCollection* assetsCollection;
@property (nonatomic, weak) NSIndexPath* indexPath;
@property (nonatomic, weak) NSMutableOrderedSet* selectedAssets;
@property (nonatomic, weak) NSArray* indexPathsForSelectedItems;    // strong?
@property (nonatomic, weak) LKImagePickerControllerSelectViewController* selectViewController;
@end

//
//  LKImagePickerControllerFilterSelectionViewController.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImagePickerControllerAssetsManager.h"

@class LKImagePickerControllerSelectViewController;

@interface LKImagePickerControllerFilterSelectionViewController : UITableViewController

@property (weak, nonatomic) LKImagePickerControllerAssetsManager* assetsManager;
@property (weak, nonatomic) LKImagePickerControllerSelectViewController* selectViewController;

@end

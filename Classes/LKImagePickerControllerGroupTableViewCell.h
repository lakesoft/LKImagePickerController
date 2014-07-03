//
//  LKImagePickerControllerGroupTableViewCell.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/30.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"

#define LKImagePickerControllerGroupTableViewControllerCellHeight   64

@interface LKImagePickerControllerGroupTableViewCell : UITableViewCell

@property (nonatomic, weak) LKAssetsGroup* assetsGroup;

@end

//
//  LKImagePickerControllerGroupTableViewController.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2014/06/12.
//
//

#import <UIKit/UIKit.h>
#import "LKAssetsLibrary.h"

@class LKImagePickerControllerSelectViewController;
@interface LKImagePickerControllerGroupTableViewController : UITableViewController

@property (weak, nonatomic) LKAssetsLibrary* assetsLibrary;
@property (weak, nonatomic) LKAssetsGroup* assetsGroup;

@property (weak, nonatomic) LKImagePickerControllerSelectViewController* selectViewController;

@end

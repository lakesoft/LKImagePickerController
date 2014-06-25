//
//  LKImagePickerControllerGroupTableViewController.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2014/06/12.
//
//

#import <UIKit/UIKit.h>
#import "LKImagePickerControllerAssetsManager.h"

@class LKImagePickerControllerSelectViewController;
@interface LKImagePickerControllerGroupTableViewController : UITableViewController

@property (weak, nonatomic) LKImagePickerControllerAssetsManager* assetsManager;

@property (weak, nonatomic) LKImagePickerControllerSelectViewController* selectViewController;

@end

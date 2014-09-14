//
//  LKImagePickerController.h
//  TEST
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKImagePickerController;
@protocol LKImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(LKImagePickerController*)imagePickerController didFinishWithAssets:
(NSArray*)selectedAssets;

@optional
- (NSString*)completionButtonTitle;
- (BOOL)enableCompletionButtonWhenNoSelections;
- (UIBarButtonItem*)rightBarButtonItem;
- (BOOL)closeWhenFinish;

// [1]selected -> [2]deselected
- (void)imagePickerController:(LKImagePickerController*)imagePickerController selectedAssets:(NSArray*)selectedAssets;
- (void)imagePickerController:(LKImagePickerController*)imagePickerController deselectedAssets:(NSArray*)deselectedAssets;
@end


@interface LKImagePickerController : UINavigationController

@property (nonatomic, strong) UIColor* tintColor;
@property (nonatomic, assign) NSInteger maximumOfSelections;    // 0=No limit
@property (nonatomic, weak) id <LKImagePickerControllerDelegate> imagePickerControllerDelegate;

@end

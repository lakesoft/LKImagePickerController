//
//  LKImagePickerController.h
//  TEST
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImagePickerControllerFilter.h"

@class LKImagePickerController;
@protocol LKImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(LKImagePickerController*)imagePickerController didFinishWithAssets:
(NSArray*)selectedAssets;

@optional
- (NSString*)completionButtonTitle;
- (BOOL)enableCompletionButtonWhenNoSelections;
- (BOOL)closeWhenFinish;
- (BOOL)canSelectGroups;
- (BOOL)sortBySelectionOrder;      // YES=sort by touching order / NO=sort by date ascending (default)

// Main Screen
- (UIBarButtonItem*)leftBarButtonItem;
- (NSArray*)leftBarButtonItems;
- (UIBarButtonItem*)rightBarButtonItem;
- (NSArray*)rightBarButtonItems;
- (BOOL)disableRightBarButtonItemWhenNoSelected;
- (void)didUpdateSelections:(NSInteger)numberOfSelections;

// Selected Pictures Screen
- (UIBarButtonItem*)rightBarButtonItem2;
- (BOOL)disableRightBarButtonItem2WhenNoSelected;

// Detail Screen
- (UIBarButtonItem*)rightBarButtonItem3;
- (BOOL)disableRightBarButtonItem3WhenNoSelected;


// [1]selected -> [2]deselected
- (void)imagePickerController:(LKImagePickerController*)imagePickerController selectedAssets:(NSArray*)selectedAssets;
- (void)imagePickerController:(LKImagePickerController*)imagePickerController deselectedAssets:(NSArray*)deselectedAssets;
@end


@interface LKImagePickerController : UINavigationController


@property (nonatomic, assign) NSInteger maximumOfSelections;    // 0=No limit
@property (nonatomic, weak) IBOutlet id <LKImagePickerControllerDelegate> imagePickerControllerDelegate;
@property (nonatomic, weak, readonly) NSArray* selectedAssets;

@property (nonatomic, assign) NSUInteger availableTypes;  // combination of LKImagePickerControllerFilterType
@property (nonatomic, assign) LKImagePickerControllerFilterType currentType;
@property (nonatomic, assign) BOOL toolBarHidden;

- (void)deselectAll;
- (void)displayMainScreenAnimated:(BOOL)animated;

- (instancetype)initWithAvaliableTypes:(NSUInteger)availableTypes currentType:(LKImagePickerControllerFilterType)currentType;

- (void)markSelectedAssets;
- (void)unmarkAllAssets;


@end

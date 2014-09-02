//
//  LKImagePickerControllerAssetsManager.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
#import "LKAssetsLibrary.h"
#import <Foundation/Foundation.h>

extern NSString * const LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification;

extern NSString * const LKImagePickerControllerAssetsManagerDidChangeSelectable;
extern NSString * const LKImagePickerControllerAssetsManagerDidChangeSelectableKey;

extern NSString * const LKImagePickerControllerAssetsManagerDidSelectNotification;
extern NSString * const LKImagePickerControllerAssetsManagerDidDeselectNotification;

extern NSString * const LKImagePickerControllerAssetsManagerDidSelectHeaderNotification;
extern NSString * const LKImagePickerControllerAssetsManagerDidDeSelectHeaderNotification;

extern NSString * const LKImagePickerControllerAssetsManagerDidAllDeselectNotification;

extern NSString * const LKImagePickerControllerAssetsManagerKeyIndexPaths;          // NSArray <IndexPath>
extern NSString * const LKImagePickerControllerAssetsManagerKeyAllSelected;         // @(BOOL)
extern NSString * const LKImagePickerControllerAssetsManagerKeyNumberOfSelections;   // @(NSInteger)


typedef void(^LKImagePickerControllerAssetsManagerReloadAssetsCompletion)();

@class LKImagePickerControllerFilter;
@interface LKImagePickerControllerAssetsManager : NSObject

@property (strong, nonatomic, readonly) LKAssetsLibrary* assetsLibrary;
@property (strong, nonatomic, readonly) LKAssetsGroup* assetsGroup;
@property (strong, nonatomic, readonly) LKImagePickerControllerFilter* filter;

// Selection management
@property (assign, nonatomic) NSInteger maximumOfSelections;
@property (assign, nonatomic) BOOL selectable;
@property (assign, nonatomic, readonly) NSInteger numberOfSelected;
@property (assign, nonatomic, readonly) BOOL reachedMaximumOfSelections;

// Selection management (selectedAssets)
- (void)selectAsset:(LKAsset*)asset;
- (void)deselectAsset:(LKAsset*)asset;
- (BOOL)containsSelectedAsset:(LKAsset*)asset;
- (void)removeAllSelectedAssets;
- (NSArray*)arrayOfSelectedAssets;
- (NSArray*)sortedArrayOfSelectedAssets;

+ (instancetype)assetsManager;

- (void)reloadAssetsWithCompletion:(LKImagePickerControllerAssetsManagerReloadAssetsCompletion)completion;
- (void)reloadAssetsGroup;
- (void)setAndReloadAssetsGroup:(LKAssetsGroup*)assetsGroup;

@end

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

typedef void(^LKImagePickerControllerAssetsManagerReloadAssetsCompletion)();

@class LKImagePickerControllerFilter;
@interface LKImagePickerControllerAssetsManager : NSObject

@property (strong, nonatomic, readonly) LKAssetsLibrary* assetsLibrary;
@property (strong, nonatomic, readonly) LKAssetsGroup* assetsGroup;
@property (strong, nonatomic, readonly) LKImagePickerControllerFilter* filter;

+ (instancetype)assetsManager;

- (void)reloadAssetsWithCompletion:(LKImagePickerControllerAssetsManagerReloadAssetsCompletion)completion;
- (void)reloadAssetsGroup;
- (void)setAndReloadAssetsGroup:(LKAssetsGroup*)assetsGroup;

@end

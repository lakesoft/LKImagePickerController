//
//  LKImagePickerControllerPostedAssetsManager.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2016/09/12.
//  Copyright © 2016年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKAsset;

@interface LKImagePickerControllerMarkedAssetsManager : NSObject

+ (BOOL)isMarkedAsset:(LKAsset*)asset;

+ (void)markAssets:(NSArray*)assets;
+ (void)unmarkAssets:(NSArray*)assets;
+ (void)unmarkAllAssets;

@end

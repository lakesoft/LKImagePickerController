//
//  LKImagePickerControllerFilter.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LKImagePickerControllerFilterType) {
    LKImagePickerControllerFilterTypeAll = 0,
    LKImagePickerControllerFilterTypeJPEG,
    LKImagePickerControllerFilterTypePNG,
    LKImagePickerControllerFilterTypeScreenShot,
    LKImagePickerControllerFilterTypeVideo,
    LKImagePickerControllerFilterTypeMax
};


@class LKAssetsCollectionGenericFilter;

@interface LKImagePickerControllerFilter : NSObject

@property (nonatomic, assign) LKImagePickerControllerFilterType type;

- (NSInteger)numberOfTypes;
- (LKImagePickerControllerFilterType)typeAtIndex:(NSInteger)index;

- (NSString*)descriptionFotType:(LKImagePickerControllerFilterType)type;

- (LKAssetsCollectionGenericFilter*)assetsFilter;

@end

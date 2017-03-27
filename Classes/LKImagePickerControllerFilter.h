//
//  LKImagePickerControllerFilter.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKAssetsLibrary/LKAssetsCollectionGenericFilter.h>
typedef NS_ENUM(NSUInteger, LKImagePickerControllerFilterType) {
    LKImagePickerControllerFilterTypeJPEG       = (1 << 0),
    LKImagePickerControllerFilterTypePNG        = (1 << 1),
    LKImagePickerControllerFilterTypeScreenShot = (1 << 2),
    LKImagePickerControllerFilterTypeVideo      = (1 << 3),
    LKImagePickerControllerFilterTypeAll        = 0xFFFFFFFF
};

@class LKAssetsCollectionGenericFilter;

@interface LKImagePickerControllerFilter : NSObject

// combination of LKImagePickerControllerFilterType
@property (nonatomic, assign) LKImagePickerControllerFilterType currentType;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign, readonly) NSUInteger availableTypes;

// for list
@property (nonatomic, strong, readonly) NSArray* filterTypes;

+ (NSArray*)allFilterTypes;

- (instancetype)initWithAvailableTypes:(NSUInteger)availableTypes currentType:(LKImagePickerControllerFilterType)currentType;

- (LKImagePickerControllerFilterType)typeAtIndex:(NSInteger)index;
- (NSString*)descriptionForType:(LKImagePickerControllerFilterType)type;
- (LKAssetsCollectionGenericFilter*)assetsFilter;

@end

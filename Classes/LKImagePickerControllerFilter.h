//
//  LKImagePickerControllerFilter.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LKImagePickerControllerFilterType) {
    LKImagePickerControllerFilterTypeJPEG       = (1 << 0),
    LKImagePickerControllerFilterTypePNG        = (1 << 1),
    LKImagePickerControllerFilterTypeScreenShot = (1 << 2),
    LKImagePickerControllerFilterTypeVideo      = (1 << 3),
    LKImagePickerControllerFilterTypeAll        = 0xFFFFFFFF
};

@class LKAssetsCollectionGenericFilter;

@interface LKImagePickerControllerFilter : NSObject

@property (nonatomic, assign) LKImagePickerControllerFilterType type;
@property (nonatomic, assign, readonly) NSUInteger availableTypes;
@property (nonatomic, strong, readonly) NSArray* filterTypes;

+ (NSArray*)allFilterTypes;

- (instancetype)initWithAvailableTypes:(NSUInteger)availableTypes;

- (LKImagePickerControllerFilterType)typeAtIndex:(NSInteger)index;
- (NSString*)descriptionFotType:(LKImagePickerControllerFilterType)type;
- (LKAssetsCollectionGenericFilter*)assetsFilter;

@end

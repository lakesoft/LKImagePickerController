//
//  LKImagePickerControllerFilter.m
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerFilter.h"
#import <LKAssetsLibrary/LKAssetsLibrary.h>
#import "LKImagePickerControllerBundleManager.h"

@interface LKImagePickerControllerFilter()
@property (nonatomic, assign) NSUInteger availableTypes;
@property (nonatomic, strong) NSArray* filterTypes;

@end

@implementation LKImagePickerControllerFilter

+ (NSArray*)allFilterTypes
{
    NSArray* array = @[@(LKImagePickerControllerFilterTypeAll),
                       @(LKImagePickerControllerFilterTypeJPEG),
                       @(LKImagePickerControllerFilterTypePNG),
                       @(LKImagePickerControllerFilterTypeScreenShot),
                       @(LKImagePickerControllerFilterTypeVideo),
                       ];
    return array;
}


- (void)_setupFilterTypes
{
    NSMutableArray* array = @[].mutableCopy;
    for (NSNumber* number in LKImagePickerControllerFilter.allFilterTypes) {
        if (number.unsignedIntegerValue & _availableTypes) {
            [array addObject:number];
        }
    }
    self.filterTypes = array;
}

- (instancetype)init
{
    return [self initWithAvailableTypes:LKImagePickerControllerFilterTypeAll currentType:LKImagePickerControllerFilterTypeAll];
}


- (instancetype)initWithAvailableTypes:(NSUInteger)availableTypes currentType:(LKImagePickerControllerFilterType)currentType
{
    self = [super init];
    if (self) {
        self.availableTypes = availableTypes;
        self.currentType = currentType;
        [self _setupFilterTypes];
    }
    return self;
}


- (NSString*)descriptionForType:(LKImagePickerControllerFilterType)type
{
    NSString* key;
    switch (type) {
        case LKImagePickerControllerFilterTypeJPEG:
            key = @"Filter.JPEG";
            break;
            
        case LKImagePickerControllerFilterTypePNG:
            key = @"Filter.PNG";
            break;
            
        case LKImagePickerControllerFilterTypeScreenShot:
            key = @"Filter.ScreenShot";
            break;

        case LKImagePickerControllerFilterTypeVideo:
            key = @"Filter.Video";
            break;

        case LKImagePickerControllerFilterTypeAll:
        default:
            key = @"Filter.All";
            break;
    }
    return [LKImagePickerControllerBundleManager localizedStringForKey:key];
}

- (LKImagePickerControllerFilterType)typeAtIndex:(NSInteger)index
{
    NSNumber* number = self.filterTypes[index];
    return number.unsignedIntegerValue;
}

- (NSString*)description
{
    return [self descriptionForType:self.currentType];
}

- (LKAssetsCollectionGenericFilter*)assetsFilter
{
    LKImagePickerControllerFilterType type = self.currentType & self.availableTypes;
    LKAssetsCollectionGenericFilterType genericFilterType = 0;

    if (type & LKImagePickerControllerFilterTypeJPEG) {
        genericFilterType |= LKAssetsCollectionGenericFilterTypeJPEG;
    }
    if (type & LKImagePickerControllerFilterTypePNG) {
        genericFilterType |= LKAssetsCollectionGenericFilterTypePNG;
    }
    if (type & LKImagePickerControllerFilterTypeScreenShot) {
        genericFilterType |= LKAssetsCollectionGenericFilterTypeScreenShot;
    }
    if (type & LKImagePickerControllerFilterTypeVideo) {
        genericFilterType |= LKAssetsCollectionGenericFilterTypeVideo;
    }
    return [LKAssetsCollectionGenericFilter filterWithType:genericFilterType];
}


@end

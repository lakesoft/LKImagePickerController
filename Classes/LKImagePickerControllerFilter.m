//
//  LKImagePickerControllerFilter.m
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerFilter.h"
#import "LKAssetsLibrary.h"
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
    self = [super init];
    if (self) {
        self.availableTypes = LKImagePickerControllerFilterTypeAll;
        [self _setupFilterTypes];
    }
    return self;
}


- (instancetype)initWithAvailableTypes:(NSUInteger)availableTypes
{
    self = [super init];
    if (self) {
        self.availableTypes = availableTypes;
        [self _setupFilterTypes];
    }
    return self;
}


- (NSString*)descriptionFotType:(LKImagePickerControllerFilterType)type
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
    return [self descriptionFotType:self.type];
}

- (LKAssetsCollectionGenericFilter*)assetsFilter
{
    LKAssetsCollectionGenericFilter* assetsFilter = nil;
    switch (self.type) {
        case LKImagePickerControllerFilterTypeJPEG:
            assetsFilter =[LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeJPEG];
            break;
            
        case LKImagePickerControllerFilterTypePNG:
            assetsFilter =[LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypePNG];
            break;
            
        case LKImagePickerControllerFilterTypeScreenShot:
            assetsFilter =[LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeScreenShot];
            break;
            
        case LKImagePickerControllerFilterTypeVideo:
            assetsFilter =[LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeVideo];
            break;
            
        case LKImagePickerControllerFilterTypeAll:
        default:
            assetsFilter =[LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeAll];
            break;
    }
    return assetsFilter;
}


@end

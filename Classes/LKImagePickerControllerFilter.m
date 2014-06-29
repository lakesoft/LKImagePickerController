//
//  LKImagePickerControllerFilter.m
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerFilter.h"
#import "LKAssetsLibrary.h"

@interface LKImagePickerControllerFilter()
@end

@implementation LKImagePickerControllerFilter

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString*)descriptionFotType:(LKImagePickerControllerFilterType)type
{
    NSString* key;
    switch (type) {
        case LKImagePickerControllerFilterTypeJPEG:
            key = @"JPEG";
            break;
            
        case LKImagePickerControllerFilterTypePNG:
            key = @"PNG";
            break;
            
        case LKImagePickerControllerFilterTypeScreenShot:
            key = @"スクリーンショット";
            break;

        case LKImagePickerControllerFilterTypeVideo:
            key = @"動画";
            break;

        case LKImagePickerControllerFilterTypeAll:
        default:
            key = @"すべて";
            break;
    }
    return NSLocalizedString(key, nil);
}

- (NSInteger)numberOfTypes
{
    return LKImagePickerControllerFilterTypeMax;
}

- (LKImagePickerControllerFilterType)typeAtIndex:(NSInteger)index
{
    return index;
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

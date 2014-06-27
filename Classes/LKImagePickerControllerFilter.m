//
//  LKImagePickerControllerFilter.m
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerFilter.h"

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

        case LKImagePickerControllerFilterTypeMovie:
            key = @"動画";
            break;

        case LKImagePickerControllerFilterTypeAll:
        default:
            key = @"すべて";
            break;
    }
    return NSLocalizedString(key, nil);
}

- (NSArray*)allTypes
{
    NSMutableArray* array = @[].mutableCopy;
    for (int i=0; i < LKImagePickerControllerFilterTypeMax; i++) {
        [array addObject:@(i)];
    }
    return array;
}

- (NSString*)description
{
    return [self descriptionFotType:self.type];
}

@end

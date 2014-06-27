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
    LKImagePickerControllerFilterTypeMovie,
    LKImagePickerControllerFilterTypeMax
};

@interface LKImagePickerControllerFilter : NSObject

@property (nonatomic, assign) LKImagePickerControllerFilterType type;
@property (nonatomic, strong, readonly) NSArray* allTypes;

- (NSString*)descriptionFotType:(LKImagePickerControllerFilterType)type;

@end

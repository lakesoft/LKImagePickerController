//
//  LKImagePickerController.h
//  TEST
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LKImagePickerControllerEntryPoint) {
    LKImagePickerControllerEntryPointWithGroups = 0,
    LKImagePickerControllerEntryPointWithSavedPhotos = 1
};



@interface LKImagePickerController : UINavigationController

@property (nonatomic, assign) LKImagePickerControllerEntryPoint entryPoint;
@property (nonatomic, strong) UIColor* checkmarkForegroundColor;
@property (nonatomic, strong) UIColor* checkmarkBackgroundColor;

@end

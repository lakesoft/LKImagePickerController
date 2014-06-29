//
//  LKImagePickerControllerBundleManager.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/30.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerBundleManager.h"

@implementation LKImagePickerControllerBundleManager

+ (NSBundle*)bundle
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"LKImagePickerController-Resources" ofType:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithPath:path];
    return bundle;
}

@end

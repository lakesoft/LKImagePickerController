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
    static NSBundle* _bundle = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSString* path = [[NSBundle mainBundle] pathForResource:@"LKImagePickerController-Resources" ofType:@"bundle"];
//        _bundle = [NSBundle bundleWithPath:path];
        // http://qiita.com/masahiko24/items/e4abfa8dce6d2d80c0cf
        _bundle = [NSBundle bundleForClass:[self class]];
    });
    return _bundle;
}

+ (NSString*)localizedStringForKey:(NSString*)key
{
    return NSLocalizedStringFromTableInBundle(key, nil, self.bundle, nil);
}

@end

//
//  LKImagePickerControllerAppearance.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerAppearance.h"

@implementation LKImagePickerControllerAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.foregroundColor = UIColor.whiteColor;
        self.backgroundColor = [UIColor colorWithRed:0.078 green:0.43 blue:0.87 alpha:1.000];
        _tintColor = _backgroundColor;
    }
    return self;
}

+ (instancetype)sharedAppearance
{
    static LKImagePickerControllerAppearance* _sharedApperance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedApperance = self.new;
    });
    return _sharedApperance;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.backgroundColor = tintColor;
}

@end

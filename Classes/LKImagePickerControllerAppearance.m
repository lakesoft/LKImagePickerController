//
//  LKImagePickerControllerAppearance.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerAppearance.h"

NSString* const LKImagePickerControllerAppearanceDidChangeTintColorNotification = @"LKImagePickerControllerAppearanceDidChangeTintColorNotification";

@implementation LKImagePickerControllerAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.foregroundColor = UIColor.whiteColor;
        self.backgroundColor = [UIColor colorWithRed:0.078 green:0.43 blue:0.87 alpha:1.000];
        self.navigationBarColor = [UIColor colorWithRed:0.276 green:0.534 blue:0.975 alpha:1.000];
        self.alertColor = UIColor.redColor;

        self.usedColor = _backgroundColor;
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
    self.navigationBarColor = tintColor;
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerAppearanceDidChangeTintColorNotification object:nil];
}

@end

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
        self.navigationBarColor = [UIColor colorWithRed:0.276 green:0.534 blue:0.975 alpha:1.000];
        self.navigationFontColor = UIColor.whiteColor;

        self.dayBoxColor = self.navigationBarColor = [UIColor colorWithRed:0.276 green:0.534 blue:0.975 alpha:1.000];
        self.dateFontColor = self.navigationBarColor = [UIColor colorWithRed:0.276 green:0.534 blue:0.975 alpha:1.000];

        self.checkForegroundColor = UIColor.whiteColor;
        self.checkBackgroundColor = [UIColor colorWithRed:0.078 green:0.43 blue:0.87 alpha:1.000];

        self.alertColor = UIColor.redColor;

        self.usedColor = _checkBackgroundColor;
        self.toolbarFontColor = self.checkBackgroundColor;
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

@end

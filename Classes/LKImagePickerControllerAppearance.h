//
//  LKImagePickerControllerAppearance.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKImagePickerControllerAppearance : NSObject

@property (strong, nonatomic) UIColor* navigationBarColor;
@property (strong, nonatomic) UIColor* navigationFontColor;

@property (strong, nonatomic) UIColor* dayBoxColor;
@property (strong, nonatomic) UIColor* dateFontColor;

@property (strong, nonatomic) UIColor* checkForegroundColor;
@property (strong, nonatomic) UIColor* checkBackgroundColor;

@property (strong, nonatomic) UIColor* toolbarFontColor;

@property (strong, nonatomic) UIColor* alertColor;
@property (strong, nonatomic) UIColor* usedColor;

+ (instancetype)sharedAppearance;

@end

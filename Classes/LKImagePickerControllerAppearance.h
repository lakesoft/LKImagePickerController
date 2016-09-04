//
//  LKImagePickerControllerAppearance.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKImagePickerControllerAppearance : NSObject

@property (strong, nonatomic) UIColor* foregroundColor;
@property (strong, nonatomic) UIColor* backgroundColor;
@property (strong, nonatomic) UIColor* navigationBarColor;
@property (strong, nonatomic) UIColor* alertColor;
@property (strong, nonatomic) UIColor* usedColor;

@property (strong, nonatomic) UIColor* tintColor;
@property (strong, nonatomic) UIColor* fontColor;
@property (strong, nonatomic) UIColor* toolbarFontColor;

+ (instancetype)sharedAppearance;

@end

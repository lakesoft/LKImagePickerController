//
//  LKImagePickerControlelrCheckmarkButton.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/07/02.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKImagePickerControlelrCheckmarkButton : UIButton

@property (nonatomic, assign) BOOL active;
+ (instancetype)checkmarkButtonWithTarget:(id)target action:(SEL)action;

@end

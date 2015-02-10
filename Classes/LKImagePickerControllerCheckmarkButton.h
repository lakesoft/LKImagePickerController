//
//  LKImagePickerControlelrCheckmarkButton.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/07/02.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKImagePickerControllerCheckmarkButton : UIButton

@property (nonatomic, assign) BOOL checked;
+ (instancetype)checkmarkButtonWithTarget:(id)target action:(SEL)action size:(CGSize)size;
- (void)alert;

@end

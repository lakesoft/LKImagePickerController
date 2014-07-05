//
//  LKImagePickerControllerCheckmarkView.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKImagePickerControllerCheckmarkView : UIView

@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) BOOL active;

+ (LKImagePickerControllerCheckmarkView*)checkmarkViewWithTarget:(id)target action:(SEL)action;

- (void)alert;

@end

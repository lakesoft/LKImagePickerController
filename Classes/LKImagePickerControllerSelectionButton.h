//
//  LKImagePickerControllerSelectionButton.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/24.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKImagePickerControllerSelectionButton : UIButton

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) NSInteger numberOfSelections;

+ (instancetype)selectionButtonTarget:(id)target action:(SEL)action;

@end

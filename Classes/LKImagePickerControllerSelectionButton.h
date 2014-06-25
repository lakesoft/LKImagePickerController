//
//  LKImagePickerControllerSelectionButton.h
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/24.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKImagePickerControllerSelectionButton : UIButton

+ (instancetype)selectionButtonTarget:(id)target action:(SEL)action;
- (void)setNumberOfSelections:(NSInteger)numberOfSelections;

@end

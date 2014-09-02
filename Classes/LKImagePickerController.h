//
//  LKImagePickerController.h
//  TEST
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKImagePickerController;
@protocol LKImagePickerControllerDelegate <NSObject>

@optional
- (NSString*)completionButtonTitle;
- (BOOL)enableCompletionButtonWhenNoSelections;
- (UIBarButtonItem*)rightBarButtonItem;
//- (void)imagePickerController:(LKImagePickerController*)imagePickerController;
@end


@interface LKImagePickerController : UINavigationController

@property (nonatomic, strong) UIColor* tintColor;
@property (nonatomic, assign) NSInteger maximumOfSelections;
@property (nonatomic, weak) id <LKImagePickerControllerDelegate> imagePickerControllerDelegate;

@end

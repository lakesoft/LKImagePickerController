//
//  LKImagePickerControllerCloseButton.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/07/03.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerCloseButton.h"
#import "LKImagePickerControllerAppearance.h"

@implementation LKImagePickerControllerCloseButton

+ (instancetype)closeButtonWithTarget:(id)target action:(SEL)action
{
    LKImagePickerControllerCloseButton* button = [self buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 28, 28);
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define LKImagePickerControllerCloseButtonMargin    4.5
#define LKImagePickerControllerCloseButtonOffset    2.0
- (void)drawRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGRect frame = CGRectInset(self.bounds, LKImagePickerControllerCloseButtonMargin, LKImagePickerControllerCloseButtonMargin);
    CGPoint p1 = CGPointMake(frame.origin.x, frame.origin.y+LKImagePickerControllerCloseButtonOffset);
    CGPoint p2 = CGPointMake(frame.size.width, frame.size.height+LKImagePickerControllerCloseButtonOffset);
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    p1.y = frame.size.height + LKImagePickerControllerCloseButtonOffset;
    p2.y = frame.origin.y + LKImagePickerControllerCloseButtonOffset;
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    
    [LKImagePickerControllerAppearance.sharedAppearance.tintColor setStroke];
    [path stroke];
}

@end

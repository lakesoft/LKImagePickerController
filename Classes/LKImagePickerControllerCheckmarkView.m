//
//  LKImagePickerControllerCheckmarkView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerCheckmarkView.h"
#import "LKImagePickerControllerAppearance.h"

@implementation LKImagePickerControllerCheckmarkView

- (void)_setup
{
    self.backgroundColor = UIColor.clearColor;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor* strokeColor = LKImagePickerControllerAppearance.sharedAppearance.checkmarkForegroundColor;
    UIColor* fillColor = LKImagePickerControllerAppearance.sharedAppearance.checkmarkBackgroundColor;
    if (self.disabled) {
        UIColor* tmp = strokeColor;
        strokeColor = fillColor;
        fillColor = tmp;
    }
    [strokeColor setStroke];
    [fillColor setFill];

    CGFloat lineWidth = self.disabled ? 1.0 : 1.5;

    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 3.0, 3.0)];
    if (self.disabled) {
        strokeColor = UIColor.whiteColor;
        [strokeColor setStroke];
    } else {
        [circlePath fill];
    }
    [circlePath setLineWidth:lineWidth];
    [circlePath stroke];
    [circlePath stroke];
    
    
    UIBezierPath* linePath = UIBezierPath.bezierPath;
    CGSize size = self.frame.size;
    [linePath moveToPoint:CGPointMake(size.width*0.30, size.height*0.5)];
    [linePath addLineToPoint:CGPointMake(size.width*0.45, size.height*0.65)];
    [linePath addLineToPoint:CGPointMake(size.width*0.70, size.height*0.37)];
    [linePath setLineWidth:lineWidth];
    [linePath stroke];
}

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    self.alpha = disabled ? 0.75 : 1.0;
}

@end

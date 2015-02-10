//
//  LKImagePickerControllerCheckmarkView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerCheckmarkView.h"
#import "LKImagePickerControllerAppearance.h"

#define LKImagePickerControllerCheckmarkViewMargin  5.0

@interface LKImagePickerControllerCheckmarkView()
@property (nonatomic, assign) BOOL alerting;
@end

@implementation LKImagePickerControllerCheckmarkView

- (void)_setup
{
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.05];
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
    UIColor* strokeColor = LKImagePickerControllerAppearance.sharedAppearance.foregroundColor;
    UIColor* fillColor = LKImagePickerControllerAppearance.sharedAppearance.backgroundColor;
    CGFloat lineWidth = 1.5;

    if (self.alerting) {
        fillColor = LKImagePickerControllerAppearance.sharedAppearance.alertColor;
    } else if (self.disabled) {
        UIColor* tmp = strokeColor;
        strokeColor = fillColor;
        fillColor = tmp;
        lineWidth = 1.0;
    } else if (!self.checked) {
        fillColor = UIColor.clearColor;
        lineWidth = 1.0;
    }

    [strokeColor setStroke];
    [fillColor setFill];

    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, LKImagePickerControllerCheckmarkViewMargin, LKImagePickerControllerCheckmarkViewMargin)];
    if (self.disabled && !self.alerting) {
        strokeColor = UIColor.whiteColor;
        [strokeColor setStroke];
    } else {
        [circlePath fill];
    }
    [circlePath setLineWidth:lineWidth];
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

- (void)setChecked:(BOOL)active
{
    _checked = active;
    [self setNeedsDisplay];
}

- (void)setAlerting:(BOOL)alerting
{
    _alerting = alerting;
    [self setNeedsDisplay];
}

- (void)alert
{
    BOOL hidden = self.hidden;
    self.hidden = NO;
    self.alerting = YES;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [CATransaction setCompletionBlock:^{
        self.hidden = hidden;
        self.alerting = NO;
    }];
    animation.duration = 0.065f;
    animation.autoreverses = YES;
    animation.repeatCount = 3;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    [self.layer addAnimation:animation forKey:@"blink"];
}


@end

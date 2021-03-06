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

- (void)_drawWithStrokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor lineWidth:(CGFloat)lineWidth circleLineWith:(CGFloat)circleLineWith offset:(CGSize)offset
{
    [strokeColor setStroke];
    [fillColor setFill];
    
    CGRect bounds = CGRectOffset(self.bounds, offset.width, offset.height);
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(bounds, LKImagePickerControllerCheckmarkViewMargin, LKImagePickerControllerCheckmarkViewMargin)];
    if (self.disabled && !self.alerting) {
        strokeColor = UIColor.whiteColor;
        [strokeColor setStroke];
    } else {
        [circlePath fill];
    }
    [circlePath setLineWidth:circleLineWith];
    [circlePath stroke];
    
    UIBezierPath* linePath = UIBezierPath.bezierPath;
    CGSize size = bounds.size;
    [linePath moveToPoint:CGPointMake(size.width*0.30+offset.width, size.height*0.5 + offset.height)];
    [linePath addLineToPoint:CGPointMake(size.width*0.45+offset.width, size.height*0.65 + offset.height)];
    [linePath addLineToPoint:CGPointMake(size.width*0.70+offset.width, size.height*0.37 + offset.height)];
    [linePath setLineWidth:lineWidth];
    [linePath stroke];
    
}
- (void)drawRect:(CGRect)rect
{
    CGFloat ds = rect.size.width > 40 ? 1.5 : 0;    // size adjustment
    UIColor* strokeColor = LKImagePickerControllerAppearance.sharedAppearance.checkForegroundColor;
    UIColor* fillColor = LKImagePickerControllerAppearance.sharedAppearance.checkBackgroundColor;
    CGFloat lineWidth = 1.5;
//    CGFloat circleLineWith = 1.0 + ds;
    CGFloat circleLineWith = 1.0;

    if (self.alerting) {
        fillColor = LKImagePickerControllerAppearance.sharedAppearance.alertColor;
    } else if (self.disabled) {
        UIColor* tmp = strokeColor;
        strokeColor = fillColor;
        fillColor = tmp;
    } else if (!self.checked) {
        fillColor = [UIColor colorWithWhite:0.0 alpha:0.05];
        lineWidth += ds;
//        circleLineWith = 1.0;
    }

    [self _drawWithStrokeColor:strokeColor fillColor:fillColor lineWidth:lineWidth circleLineWith:circleLineWith offset:CGSizeMake(0, 0)];
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

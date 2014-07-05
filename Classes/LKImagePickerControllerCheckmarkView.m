//
//  LKImagePickerControllerCheckmarkView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerCheckmarkView.h"
#import "LKImagePickerControllerAppearance.h"

@interface LKImagePickerControllerCheckmarkView()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) BOOL alerting;
@end
@implementation LKImagePickerControllerCheckmarkView

- (void)_setup
{
    self.backgroundColor = UIColor.clearColor;
    _active = YES;
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

+ (LKImagePickerControllerCheckmarkView*)checkmarkViewWithTarget:(id)target action:(SEL)action
{
    LKImagePickerControllerCheckmarkView* view = LKImagePickerControllerCheckmarkView.new;
    view.target = target;
    view.action = action;
    return view;
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
    } else if (!self.active) {
        strokeColor = fillColor;
        fillColor = UIColor.clearColor;
        lineWidth = 1.0;
    }

    [strokeColor setStroke];
    [fillColor setFill];

    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 3.0, 3.0)];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.target && self.action) {
// @see http://captainshadow.hatenablog.com/entry/20121114/1352834276
//        [self.target performSelector:_action withObject:self];
        [self.target performSelector:self.action withObject:self afterDelay:0];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)setActive:(BOOL)active
{
    _active = active;
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

//
//  LKImagePickerControllerCheckmarkView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerCheckmarkView.h"

@implementation LKImagePickerControllerCheckmarkView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [UIColor.whiteColor setStroke];
    [[UIColor colorWithRed:0.078 green:0.43 blue:0.87 alpha:1.000] setFill];

    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 3.0, 3.0)];
    [circlePath fill];
    [circlePath setLineWidth:1.5];
    [circlePath stroke];
    
    UIBezierPath* linePath = UIBezierPath.bezierPath;
    CGSize size = self.frame.size;
    [linePath moveToPoint:CGPointMake(size.width*0.30, size.height*0.5)];
    [linePath addLineToPoint:CGPointMake(size.width*0.45, size.height*0.65)];
    [linePath addLineToPoint:CGPointMake(size.width*0.70, size.height*0.37)];
    [linePath setLineWidth:1.5];
    [linePath stroke];
}

@end

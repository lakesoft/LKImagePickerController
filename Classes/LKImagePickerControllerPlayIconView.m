//
//  LKImagePickerControllerPlayIconView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/29.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerPlayIconView.h"

@implementation LKImagePickerControllerPlayIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // frame
//    UIBezierPath* path1 = [UIBezierPath bezierPathWithRect:self.bounds];
//    [[UIColor colorWithWhite:1.0 alpha:1.0] set];
//    [path1 setLineWidth:2.0];
//    [path1 stroke];
    
    // triangle
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    CGFloat r = self.bounds.size.height / 50.0;
    CGFloat offset = 14*r;
    [path2 moveToPoint:CGPointMake(offset+7.0*r, 16.0*r)];
    [path2 addLineToPoint:CGPointMake(offset+7.0*r, 48.0*r)];
    [path2 addLineToPoint:CGPointMake(offset+37.0*r, 32.0*r)];
    [path2 closePath];
//    [[UIColor colorWithWhite:0.25 alpha:0.25] set];
    [[UIColor colorWithWhite:1.0 alpha:1.0] set];
    [path2 fill];
}

@end

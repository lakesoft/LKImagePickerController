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
//    UIBezierPath* path1 = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0];
//    [[UIColor colorWithWhite:1.0 alpha:0.75] set];
//    [path1 setLineWidth:1.0];
//    [path1 fill];
    
    // triangle
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    CGFloat r = self.bounds.size.height / 70.0;
    CGFloat offset = 14*r;
    [path2 moveToPoint:CGPointMake(offset+25.0*r, 17.0*r)];
    [path2 addLineToPoint:CGPointMake(offset+25.0*r, 52.0*r)];
    [path2 addLineToPoint:CGPointMake(offset+55.0*r, 35.0*r)];
    [path2 closePath];
//    [[UIColor colorWithWhite:0.25 alpha:0.5] set];
    [[UIColor colorWithWhite:1.0 alpha:0.75] set];
    [path2 fill];
}

@end

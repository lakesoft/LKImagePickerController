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
    // triangle
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    CGFloat r = self.bounds.size.height / 50.0;
    CGFloat offset = 14*r;
    [path2 moveToPoint:CGPointMake(offset+7.0*r, 16.0*r)];
    [path2 addLineToPoint:CGPointMake(offset+7.0*r, 48.0*r)];
    [path2 addLineToPoint:CGPointMake(offset+37.0*r, 32.0*r)];
    [path2 closePath];

    [[UIColor colorWithWhite:1.0 alpha:0.8] setFill];
    [path2 fill];
    
    [[UIColor colorWithWhite:0.0 alpha:0.1] setStroke];
    [path2 setLineWidth:1.0];
    [path2 stroke];
}

@end

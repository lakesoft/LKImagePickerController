//
//  LKImagePickerControllerUsedMarkView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/07/05.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerUsedMarkView.h"
#import "LKImagePickerControllerAppearance.h"

@implementation LKImagePickerControllerUsedMarkView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CALayer* layer = self.layer;
        layer.cornerRadius = self.bounds.size.width/2.0;
        layer.borderWidth = 0.5;
        layer.masksToBounds = YES;
    }
    return self;
}

- (void)setOn:(BOOL)on
{
    _on = on;
    CALayer* layer = self.layer;
    if (on) {
        layer.backgroundColor = LKImagePickerControllerAppearance.sharedAppearance.usedColor.CGColor;
        layer.borderColor = LKImagePickerControllerAppearance.sharedAppearance.usedBorderColor.CGColor;
    } else {
        layer.backgroundColor = UIColor.clearColor.CGColor;
        layer.borderColor = UIColor.clearColor.CGColor;
    }
    [self setNeedsDisplay];
}

@end

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
        layer.borderWidth = 1.0;
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
        layer.borderColor = UIColor.clearColor.CGColor;
    } else {
        layer.backgroundColor = UIColor.clearColor.CGColor;
        layer.borderColor = LKImagePickerControllerAppearance.sharedAppearance.usedColor.CGColor;
    }
    [self setNeedsDisplay];
}

@end

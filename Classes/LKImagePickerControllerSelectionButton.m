//
//  LKImagePickerControllerSelectionButton.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/24.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerSelectionButton.h"
#import "LKImagePickerControllerAppearance.h"

#define  LKImagePickerControllerSelectionButtonSize 34.0

@implementation LKImagePickerControllerSelectionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        [self setNumberOfSelections:0];
        
        CALayer* layer = self.layer;
        layer.borderColor = LKImagePickerControllerAppearance.sharedAppearance.backgroundColor.CGColor;
        layer.borderWidth = 0.0;
    }
    return self;
}

+ (instancetype)selectionButtonTarget:(id)target action:(SEL)action
{
    LKImagePickerControllerSelectionButton* selectionButton = [[self alloc] initWithFrame:CGRectMake(0, 0, 43.7, 27)];
    [selectionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return selectionButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)_updateUI
{
    [self setTitle:[NSString stringWithFormat:@"%zd", self.numberOfSelections]
          forState:UIControlStateNormal];
    self.enabled = YES;
    if (self.active) {
        [self setTitleColor:LKImagePickerControllerAppearance.sharedAppearance.foregroundColor forState:UIControlStateNormal];
        self.backgroundColor = LKImagePickerControllerAppearance.sharedAppearance.backgroundColor;
        self.layer.borderWidth = 0.0;
    } else {
        [self setTitleColor:LKImagePickerControllerAppearance.sharedAppearance.backgroundColor forState:UIControlStateNormal];
        self.backgroundColor = UIColor.clearColor;
        self.layer.borderWidth = 1.0;
    }
}

- (void)setNumberOfSelections:(NSInteger)numberOfSelections
{
    _numberOfSelections = numberOfSelections;
    [self _updateUI];
}

- (void)setActive:(BOOL)active
{
    _active = active;
    [self _updateUI];
}


@end

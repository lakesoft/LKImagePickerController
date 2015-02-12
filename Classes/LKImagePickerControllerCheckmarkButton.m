//
//  LKImagePickerControlelrCheckmarkButton.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/07/02.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerCheckmarkButton.h"
#import "LKImagePickerControllerCheckmarkView.h"

@interface LKImagePickerControllerCheckmarkButton()
@property (nonatomic, weak) LKImagePickerControllerCheckmarkView* checkmarkView;
@end
@implementation LKImagePickerControllerCheckmarkButton

- (void)_setupView
{
    LKImagePickerControllerCheckmarkView* view = LKImagePickerControllerCheckmarkView.new;
    view.frame = self.bounds;
    [self addSubview:view];
    self.checkmarkView = view;
}

+ (instancetype)checkmarkButtonWithTarget:(id)target action:(SEL)action size:(CGSize)size
{
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    LKImagePickerControllerCheckmarkButton* button = LKImagePickerControllerCheckmarkButton.new;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    [button _setupView];

    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setupView];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    self.checkmarkView.checked = checked;
    if (self.hiddenMode) {
        self.checkmarkView.hidden = !checked;
    }
}
- (BOOL)checked
{
    return self.checkmarkView.checked;
}

- (void)alert
{
    [self.checkmarkView alert];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.checked = !self.checked;
    [super touchesEnded:touches withEvent:event];
}

@end

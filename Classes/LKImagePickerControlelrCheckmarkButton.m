//
//  LKImagePickerControlelrCheckmarkButton.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/07/02.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControlelrCheckmarkButton.h"
#import "LKImagePickerControllerCheckmarkView.h"

@interface LKImagePickerControlelrCheckmarkButton()
@property (nonatomic, weak) LKImagePickerControllerCheckmarkView* checkmarkView;
@end
@implementation LKImagePickerControlelrCheckmarkButton

+ (instancetype)checkmarkButtonWithTarget:(id)target action:(SEL)action
{
    CGRect frame = CGRectMake(0, 0, 30, 30);
    LKImagePickerControlelrCheckmarkButton* button = LKImagePickerControlelrCheckmarkButton.new;
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    LKImagePickerControllerCheckmarkView* view = [LKImagePickerControllerCheckmarkView checkmarkViewWithTarget:target action:action];
    view.frame = CGRectInset(frame, 0, 0);
    [button addSubview:view];
    
    button.checkmarkView = view;

    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setActive:(BOOL)active
{
    self.checkmarkView.active = active;
}
- (BOOL)active
{
    return self.checkmarkView.active;
}

- (void)alert
{
    [self.checkmarkView alert];
}

@end

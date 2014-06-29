//
//  LKImagePickerControllerSelectionButton.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/24.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerSelectionButton.h"
#import "LKImagePickerControllerAppearance.h"

@implementation LKImagePickerControllerSelectionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self setNumberOfSelections:0];
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

- (void)setNumberOfSelections:(NSInteger)numberOfSelections
{
    [self setTitle:[NSString stringWithFormat:@"%zd", numberOfSelections]
                forState:UIControlStateNormal];
    if (numberOfSelections > 0) {
        self.enabled = YES;
        self.backgroundColor = LKImagePickerControllerAppearance.sharedAppearance.backgroundColor;
    } else {
        self.enabled = NO;
        self.backgroundColor = UIColor.clearColor;
    }
}


@end

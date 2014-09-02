//
//  LKImagePickerControllerSelectionButton.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/24.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerSelectionButton.h"
#import "LKImagePickerControllerAppearance.h"
#import "LKImagePickerControllerAssetsManager.h"
#import "LKImagePickerControllerBundleManager.h"

//#define  LKImagePickerControllerSelectionButtonStandardWidth 43.7
#define  LKImagePickerControllerSelectionButtonStandardWidth 100.0
//#define  LKImagePickerControllerSelectionButtonStandardHeight 27.0
#define  LKImagePickerControllerSelectionButtonStandardHeight 33.0
#define  LKImagePickerControllerSelectionButtonPadding 5.0

@interface LKImagePickerControllerSelectionButton()
@property (nonatomic, weak) LKImagePickerControllerAssetsManager* assetsManager;
@end

@implementation LKImagePickerControllerSelectionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        [self setNumberOfSelections:0];
        
        CALayer* layer = self.layer;
        layer.borderWidth = 0.0;
    }
    return self;
}

+ (instancetype)selectionButtonTarget:(id)target action:(SEL)action assetsManager:(LKImagePickerControllerAssetsManager *)assetsManager
{
    LKImagePickerControllerSelectionButton* selectionButton = [[self alloc] initWithFrame:CGRectMake(0, 0, LKImagePickerControllerSelectionButtonStandardWidth, LKImagePickerControllerSelectionButtonStandardHeight)];
    [selectionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    selectionButton.assetsManager = assetsManager;

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

- (NSString*)_formattedTextWithNumberOfSelections:(NSInteger)numberOfSelections
{
    NSString* text = nil;
    if (self.assetsManager.maximumOfSelections) {
        text = [NSString stringWithFormat:@"%@ %zd/%zd",
                [LKImagePickerControllerBundleManager localizedStringForKey:@"SelectionScreen.SelectedLabel"],
                numberOfSelections, self.assetsManager.maximumOfSelections];
    } else {
        text = [NSString stringWithFormat:@"%@ %zd",
                [LKImagePickerControllerBundleManager localizedStringForKey:@"SelectionScreen.SelectedLabel"],
                numberOfSelections];
    }
    return text;
}

- (void)_updateUI
{
    [self setTitle:[self _formattedTextWithNumberOfSelections:self.numberOfSelections]
          forState:UIControlStateNormal];
    self.enabled = YES;
    if (self.alerted) {
        if (self.active) {
            [self setTitleColor:LKImagePickerControllerAppearance.sharedAppearance.foregroundColor forState:UIControlStateNormal];
            self.backgroundColor = LKImagePickerControllerAppearance.sharedAppearance.alertColor;
            self.layer.borderWidth = 0.0;
        } else {
            [self setTitleColor:LKImagePickerControllerAppearance.sharedAppearance.alertColor forState:UIControlStateNormal];
            self.backgroundColor = UIColor.clearColor;
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = LKImagePickerControllerAppearance.sharedAppearance.alertColor.CGColor;
        }
    } else {
        if (self.active) {
            [self setTitleColor:LKImagePickerControllerAppearance.sharedAppearance.foregroundColor forState:UIControlStateNormal];
            self.backgroundColor = LKImagePickerControllerAppearance.sharedAppearance.backgroundColor;
            self.layer.borderWidth = 0.0;
        } else {
            [self setTitleColor:LKImagePickerControllerAppearance.sharedAppearance.backgroundColor forState:UIControlStateNormal];
            self.backgroundColor = UIColor.clearColor;
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = LKImagePickerControllerAppearance.sharedAppearance.backgroundColor.CGColor;

        }
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

- (void)setAlerted:(BOOL)filled
{
    _alerted = filled;
    [self _updateUI];
}

- (CGFloat)maxButtonWidth
{
    if (self.assetsManager.maximumOfSelections) {
        NSString* text = [self _formattedTextWithNumberOfSelections:self.assetsManager.maximumOfSelections];
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
        size.width += LKImagePickerControllerSelectionButtonPadding * 2;
        if (size.width < LKImagePickerControllerSelectionButtonStandardWidth) {
            size.width = LKImagePickerControllerSelectionButtonStandardWidth;
        }
        return size.width;
    } else {
        return LKImagePickerControllerSelectionButtonStandardWidth;
    }
}

- (void)warnAboutExceeding
{
    self.alerted = YES;
    self.active = YES;

    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [CATransaction setCompletionBlock:^{
        self.active = NO;
    }];
    animation.duration = 0.065f;
    animation.autoreverses = YES;
    animation.repeatCount = 3;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    [self.layer addAnimation:animation forKey:@"blink"];
}

@end

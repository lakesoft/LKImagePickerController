//
//  LKImagePickerControllerEmptyView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/07/03.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerEmptyView.h"
#import "LKImagePickerControllerBundleManager.h"

@interface LKImagePickerControllerEmptyView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LKImagePickerControllerEmptyView

+ (instancetype)emptyView
{
    NSBundle* bundle = LKImagePickerControllerBundleManager.bundle;
    UINib* nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:bundle];
    LKImagePickerControllerEmptyView* view = [nib instantiateWithOwner:nil options:nil][0];
    view.titleLabel.text = [LKImagePickerControllerBundleManager localizedStringForKey:@"Common.NoPics"];
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

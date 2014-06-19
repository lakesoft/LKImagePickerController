//
//  LKImagePickerControllerSelectHeaderView.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerSelectHeaderView.h"
#import "LKImagePickerControllerSelectViewController.h"
#import "LKImagePickerControllerCheckmarkView.h"
#import "LKImagePickerControllerAppearance.h"

@interface LKImagePickerControllerSelectHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation LKImagePickerControllerSelectHeaderView

- (void)_didChangeSelection:(NSNotification*)notifiction
{
    NSIndexPath* indexPath = notifiction.userInfo[LKImagePickerControllerSelectViewControllerKeyIndexPath];
    if (self.section == indexPath.section) {
        NSNumber* allSelected = notifiction.userInfo[LKImagePickerControllerSelectViewControllerKeyAllSelected];
        self.allSelected = allSelected.boolValue;
    }
}

- (void)awakeFromNib
{
    self.allSelected = NO;
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_didChangeSelection:)
                                               name:LKImagePickerControllerSelectViewControllerDidSelectCellNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_didChangeSelection:)
                                               name:LKImagePickerControllerSelectViewControllerDidDeselectCellNotification
                                             object:nil];
}

- (void)setCollectionEntry:(LKAssetsCollectionEntry *)collectionEntry
{
    _collectionEntry = collectionEntry;
    NSDateFormatter* formatter = NSDateFormatter.new;
    formatter.dateStyle = NSDateFormatterShortStyle;
    self.titleLabel.text = [formatter stringFromDate:collectionEntry.date];
    
    [self.checkButton setTitle:[NSString stringWithFormat:@"%lu", collectionEntry.assets.count]
                      forState:UIControlStateNormal];
}

- (void)setAllSelected:(BOOL)allSelected
{
    _allSelected = allSelected;
    UIColor* buttonForegroundColor = LKImagePickerControllerAppearance.sharedAppearance.checkmarkBackgroundColor;
    UIColor* buttonBackgroundColor = UIColor.whiteColor;
    
    if (allSelected) {
        UIColor* tmp = buttonForegroundColor;
        buttonForegroundColor = buttonBackgroundColor;
        buttonBackgroundColor = tmp;
    }
    self.checkButton.tintColor = buttonForegroundColor;
    self.checkButton.backgroundColor = buttonBackgroundColor;
    CALayer* layer = self.checkButton.layer;
    layer.borderColor = buttonForegroundColor.CGColor;
    layer.borderWidth = 0.5;
}


@end

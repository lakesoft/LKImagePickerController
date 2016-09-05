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
    NSArray* array = notifiction.userInfo[LKImagePickerControllerAssetsManagerKeyIndexPaths];
    NSIndexPath* indexPath = array.firstObject;
    if (self.section == indexPath.section) {
        NSNumber* allSelected = notifiction.userInfo[LKImagePickerControllerAssetsManagerKeyAllSelected];
        self.allSelected = allSelected.boolValue;
    }
}

- (void)_didAllDeselect:(NSNotification*)notification
{
    self.allSelected = NO;
}

- (void)awakeFromNib
{
    self.allSelected = NO;
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_didChangeSelection:)
                                               name:LKImagePickerControllerAssetsManagerDidSelectNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_didChangeSelection:)
                                               name:LKImagePickerControllerAssetsManagerDidDeselectNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_didAllDeselect:)
                                               name:LKImagePickerControllerAssetsManagerDidAllDeselectNotification
                                             object:nil];

    UIColor* buttonForegroundColor = LKImagePickerControllerAppearance.sharedAppearance.checkBackgroundColor;
    CALayer* layer = self.checkButton.layer;
    layer.borderColor = buttonForegroundColor.CGColor;
    layer.borderWidth = 1.0;
}

- (void)setCollectionEntry:(LKAssetsCollectionEntry *)collectionEntry
{
    _collectionEntry = collectionEntry;
    NSDateFormatter* formatter1 = NSDateFormatter.new;
    formatter1.dateStyle = NSDateFormatterMediumStyle;
    NSString* dateString1 = [formatter1 stringFromDate:collectionEntry.date];

    NSDateFormatter* formatter2 = NSDateFormatter.new;
    formatter2.dateFormat = @"E";
    NSString* dateString2 = [formatter2 stringFromDate:collectionEntry.date];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", dateString1, dateString2];
    
    [self.checkButton setTitle:[NSString stringWithFormat:@"%zd", collectionEntry.assets.count]
                      forState:UIControlStateNormal];
    
    if (self.collectionEntry.assets.count > 0) {
        self.checkButton.enabled = YES;
        self.checkButton.layer.borderWidth = 1.0;
    } else {
        self.checkButton.enabled = NO;
        self.checkButton.layer.borderWidth = 0.0;
    }
}

- (void)setAllSelected:(BOOL)allSelected
{
    if (self.collectionEntry.assets.count == 0) {
        allSelected = NO;
    }
    _allSelected = allSelected;
    UIColor* buttonForegroundColor = LKImagePickerControllerAppearance.sharedAppearance.checkBackgroundColor;
    UIColor* buttonBackgroundColor = UIColor.whiteColor;
    
    if (allSelected) {
        UIColor* tmp = buttonForegroundColor;
        buttonForegroundColor = buttonBackgroundColor;
        buttonBackgroundColor = tmp;
    }
    self.checkButton.tintColor = buttonForegroundColor;
    self.checkButton.backgroundColor = buttonBackgroundColor;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end

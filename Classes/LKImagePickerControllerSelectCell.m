//
//  LKImagePickerControllerSelectCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
#import "LKImagePickerController.h"
#import "LKImagePickerControllerSelectCell.h"
#import "LKImagePickerControllerCheckmarkButton.h"
#import "LKImagePickerControllerUsedMarkView.h"
#import "LKImagePickerControllerSelectViewController.h"
#import "LKImagePickerControllerMarkedAssetsManager.h"
#import "LKAsset+Comment.h"
#import "LKAsset+AlternativeImage.h"
#import "LKImagePickerControllerUtility.h"

#define LKImagePickerControllerStandardSelectCellOffset 10

@interface LKImagePickerControllerSelectCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerCheckmarkButton* checkmarkButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *videoView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerUsedMarkView *usedView;
@property (weak, nonatomic) IBOutlet UIImageView *commentIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alternativeIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkButtonWidthConstraint;
@property (weak, nonatomic) CAGradientLayer* gradientLayer;
@property (weak, nonatomic) IBOutlet UIImageView *markedIconImageView;

@end

@implementation LKImagePickerControllerSelectCell

- (NSString*)_durationString
{
    NSInteger min, sec;
    double duration = self.asset.duration;
    min = (NSInteger)(duration / 60);
    sec = round(fmod(duration, 60.0));
    return [NSString stringWithFormat:@"%zd:%02zd", min, sec];
}

- (void)awakeFromNib
{
    self.gradientLayer = [LKImagePickerControllerUtility setupPlateView:self.photoImageView directionDown:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
//    self.photoImageView.image = self.asset.aspectRatioThumbnail;
    self.photoImageView.image = self.asset.alternativeAspectRatioThumbnail;
//    self.usedView.on = [LKImagePickerControllerMarkedAssetsManager isMarkedAsset:asset];
    self.markedIconImageView.hidden = ![LKImagePickerControllerMarkedAssetsManager isMarkedAsset:asset];
    self.videoView.hidden = asset.type != LKAssetTypeVideo;
    self.videoLabel.text = self._durationString;
    self.videoLabel.hidden = self.bounds.size.width < 80.0;
    self.commentIconImageView.hidden = !asset.hasComment;
    self.alternativeIconImageView.hidden = !asset.hasAlternativeImage;
    if (!self.alternativeIconImageView.hidden && self.alternativeIconImage) {
        self.alternativeIconImageView.image = self.alternativeIconImage;
    }
    self.checkButtonWidthConstraint.constant = self.bounds.size.width / 2.0;
}

- (void)alert
{
    [self.checkmarkButton alert];
}

- (BOOL)checked
{
    return self.checkmarkButton.checked;
}
- (void)setChecked:(BOOL)checked
{
    self.checkmarkButton.checked = checked;
    [self setNeedsDisplay];
}

- (void)setCheckmarkUserInteractionEnabled:(BOOL)checkmarkUserInteractionEnabled
{
    self.checkmarkButton.userInteractionEnabled = checkmarkUserInteractionEnabled;
}
- (void)setCheckmarkHiddenMode:(BOOL)checkmarkHiddenMode
{
    self.checkmarkButton.hiddenMode = checkmarkHiddenMode;
}

- (void)setCurrent:(BOOL)current
{
    _current = current;
//    self.photoImageView.alpha = current ? 1.0 : 0.6;
//    [self setNeedsDisplay];

}

- (void)setHilighted:(BOOL)higlighted
{
    self.photoImageView.alpha = higlighted ? 0.6 : 1.0;
}

- (void)flashCompletion:(void (^)())completion
{
    [UIView animateWithDuration:0.1 animations:^{
        self.photoImageView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.photoImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.07 animations:^{
                self.photoImageView.alpha = 0.5;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.07 animations:^{
                    self.photoImageView.alpha = 1.0;
                } completion:^(BOOL finished) {
                    completion();
                }];
            }];
        }];
    }];
}

@end

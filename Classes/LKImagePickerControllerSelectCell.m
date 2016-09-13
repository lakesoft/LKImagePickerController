//
//  LKImagePickerControllerSelectCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerSelectCell.h"
#import "LKImagePickerControllerCheckmarkButton.h"
#import "LKImagePickerControllerUsedMarkView.h"
#import "LKImagePickerControllerSelectViewController.h"
#import "LKImagePickerControllerMarkedAssetsManager.h"

#define LKImagePickerControllerStandardSelectCellOffset 10

@interface LKImagePickerControllerSelectCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerCheckmarkButton* checkmarkButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *videoView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerUsedMarkView *usedView;
@property (weak, nonatomic) IBOutlet UIImageView *postedIconImageView;


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

- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
    self.photoImageView.image = self.asset.thumbnail;
    BOOL marked = [LKImagePickerControllerMarkedAssetsManager isMarkedAsset:asset];
    self.photoImageView.alpha = marked ? 0.5 : 1.0;
    self.postedIconImageView.hidden = !marked;
    self.videoView.hidden = asset.type != LKAssetTypeVideo;
    self.videoLabel.text = self._durationString;
    self.videoLabel.hidden = self.bounds.size.width < 80.0;
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
    self.photoImageView.alpha = current ? 1.0 : 0.6;
    [self setNeedsDisplay];

}

@end

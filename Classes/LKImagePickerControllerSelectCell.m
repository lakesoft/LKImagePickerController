//
//  LKImagePickerControllerSelectCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/16.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerSelectCell.h"
#import "LKImagePickerControllerCheckmarkView.h"

#define LKImagePickerControllerStandardSelectCellOffset 10

@interface LKImagePickerControllerSelectCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerCheckmarkView* checkmarkView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *videoView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *videoLabel;
@end

@implementation LKImagePickerControllerSelectCell

- (NSString*)_durationString
{
    NSInteger min, sec;
    double duration = self.asset.duration;
    min = (NSInteger)(duration / 60);
    sec = ((NSInteger)duration) % 60;
    return [NSString stringWithFormat:@"%zd:%02zd", min, sec];
}

- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
    self.photoImageView.image = self.asset.thumbnail;
    self.videoView.hidden = asset.type != LKAssetTypeVideo;
    self.videoLabel.text = self._durationString;
}

- (void)awakeFromNib
{
//    self.checkmarkView.disabled = YES;
    self.checkmarkView.hidden = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    self.checkmarkView.hidden = !selected;
//    self.checkmarkView.disabled = !selected;
//    [self.checkmarkView setNeedsDisplay];
    self.alpha = selected ? 0.8 : 1.0;
    self.touchedOnCheckmark = NO;
}

//#define LKImagePickerControllerSelectCellHitThreshold   0.6
#define LKImagePickerControllerSelectCellHitThreshold   0.7

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint p = [touches.anyObject locationInView:self];
    CGSize size = self.frame.size;
//    if (1.0 - size.width*LKImagePickerControllerSelectCellHitThreshold < p.x &&  size.height*LKImagePickerControllerSelectCellHitThreshold < p.y) {
    if (p.x < size.width*LKImagePickerControllerSelectCellHitThreshold) {
        self.touchedOnCheckmark = YES;
    }
}
@end

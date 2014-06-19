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
@end

@implementation LKImagePickerControllerSelectCell


- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
    self.photoImageView.image = self.asset.thumbnail;
}

- (void)awakeFromNib
{
    self.checkmarkView.disabled = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

//    self.checkmarkView.hidden = !selected;
    self.checkmarkView.disabled = !selected;
    [self.checkmarkView setNeedsDisplay];
    self.alpha = selected ? 0.8 : 1.0;
    self.touchedOnCheckmark = NO;
}

#define LKImagePickerControllerSelectCellHitThreshold   0.6

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint p = [touches.anyObject locationInView:self];
    CGSize size = self.frame.size;
    if (size.width*LKImagePickerControllerSelectCellHitThreshold < p.x || size.height*LKImagePickerControllerSelectCellHitThreshold < p.y) {
        self.touchedOnCheckmark = YES;
    }
}
@end

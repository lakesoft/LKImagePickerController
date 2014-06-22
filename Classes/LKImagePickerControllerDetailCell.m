//
//  LKImagePickerControllerDetailCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerDetailCell.h"
#import "LKImagePickerControllerCheckmarkView.h"

@interface LKImagePickerControllerDetailCell()
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet LKImagePickerControllerCheckmarkView *checkmarkView;

@end

@implementation LKImagePickerControllerDetailCell

- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
    self.imageView.image = asset.fullScreenImage;
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
//    self.touchedOnCheckmark = NO;
}

////#define LKImagePickerControllerSelectCellHitThreshold   0.6
//#define LKImagePickerControllerSelectCellHitThreshold   0.7
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    CGPoint p = [touches.anyObject locationInView:self];
//    CGSize size = self.frame.size;
//    //    if (1.0 - size.width*LKImagePickerControllerSelectCellHitThreshold < p.x &&  size.height*LKImagePickerControllerSelectCellHitThreshold < p.y) {
//    if (p.x < size.width*LKImagePickerControllerSelectCellHitThreshold) {
//        self.touchedOnCheckmark = YES;
//    }
//}

@end

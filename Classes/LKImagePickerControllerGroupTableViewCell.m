//
//  LKImagePickerControllerGroupTableViewCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/30.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerGroupTableViewCell.h"
#import "LKImagePickerControllerBundleManager.h"

@interface LKImagePickerControllerGroupTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end


@implementation LKImagePickerControllerGroupTableViewCell

- (void)setAssetsGroup:(LKAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    self.posterImageView.image = assetsGroup.posterImage;
    self.groupTitle.text = assetsGroup.name;
    self.numberLabel.text = [NSString stringWithFormat:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.NumerOfPics"],
                             assetsGroup.numberOfAssets];
}

@end

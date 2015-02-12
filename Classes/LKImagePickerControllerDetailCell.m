//
//  LKImagePickerControllerDetailCell.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
@import MediaPlayer;

#import "LKImagePickerControllerDetailCell.h"
#import "LKImagePickerControllerCheckmarkButton.h"
#import "LKImagePickerControllerPlayIconView.h"

NSString * const LKImagePickerControllerDetailCellSingleTapNotification = @"LKImagePickerControllerDetailCellSingleTapNotification";

@interface LKImagePickerControllerDetailCell() <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerCheckmarkButton* checkmarkButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *playMovieButton;
@property (strong, nonatomic) MPMoviePlayerController* moviePlayerController;
@end

@implementation LKImagePickerControllerDetailCell

- (void)setAsset:(LKAsset *)asset
{
    _asset = asset;
    self.imageView.image = asset.fullScreenImage;
    self.scrollView.zoomScale = 1.0;
    self.playMovieButton.hidden = self.asset.type != LKAssetTypeVideo;
}

#pragma mark - Privates
- (void)_handleDoubleTap:(UITapGestureRecognizer*)tgr
{
    if (self.scrollView.zoomScale <= 1.0) {
        [self.scrollView setZoomScale:2.0 animated:YES];
        self.scrollView.zoomScale = 2.0;
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}
- (void)_handleLongPress:(UILongPressGestureRecognizer*)lpgr
{
    if (lpgr.state == UIGestureRecognizerStateEnded) {
        [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerDetailCellSingleTapNotification object:self];
    }
}

#pragma mark - MPMoviePlayerController Notifications
- (void)_moviePlayerPlaybackDidFinish:(NSNotification*)notification
{
    self.moviePlayerController.view.alpha = 0.0;
    [self.moviePlayerController.view removeFromSuperview];
    self.moviePlayerController = nil;
}

#pragma mark - Basics
- (void)awakeFromNib
{
    CGRect buttonFrame = self.playMovieButton.frame;
    buttonFrame.origin = CGPointZero;
    LKImagePickerControllerPlayIconView* iconView = [[LKImagePickerControllerPlayIconView alloc] initWithFrame:buttonFrame];
    [self.playMovieButton addSubview:iconView];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_moviePlayerPlaybackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_moviePlayerPlaybackDidFinish:)
                                               name:MPMoviePlayerDidExitFullscreenNotification
                                             object:nil];

    UITapGestureRecognizer* tgr;
    tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleTap:)];
    tgr.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:tgr];
    
    UILongPressGestureRecognizer* lprgr;
    lprgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPress:)];
    lprgr.minimumPressDuration = 0.15;
    [self.imageView addGestureRecognizer:lprgr];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)alert
{
    [self.checkmarkButton alert];
}


#define LKImagePickerControlelrDetailCellCheckmarkMargin    10.0
- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.scrollView.frame = bounds;
    self.scrollView.contentSize = bounds.size;
    self.imageView.frame = bounds;
    self.moviePlayerController.view.frame = self.bounds;

    CGRect buttonFrame;
    
    CGPoint p1 = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    buttonFrame = self.checkmarkButton.frame;
    buttonFrame.origin.x = p1.x - buttonFrame.size.width/2.0;
    buttonFrame.origin.y = p1.y - buttonFrame.size.height/2.0;
    self.checkmarkButton.frame = buttonFrame;

    buttonFrame = self.playMovieButton.frame;
    buttonFrame.origin.x = p1.x - buttonFrame.size.width/2.0;
    buttonFrame.origin.y = p1.y - buttonFrame.size.height/2.0 + buttonFrame.size.height * 1.5;
    self.playMovieButton.frame = buttonFrame;
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.checkmarkButton.checked = selected;
}

#pragma mark - UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Actions
- (IBAction)playVideo:(id)sender {
    if (self.asset.type != LKAssetTypeVideo) {
        return;
    }
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.asset.url];
    self.moviePlayerController.view.frame = self.bounds;
    self.moviePlayerController.view.alpha = 0.0;

    [self addSubview:self.moviePlayerController.view];
    [self.moviePlayerController play];
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.moviePlayerController.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self.moviePlayerController setFullscreen:YES animated:YES];
                     }];
}

#pragma mark - Event
- (void)didEndDisplay
{
    [self.moviePlayerController stop];
}


#pragma mark - Properties
- (BOOL)checked
{
    return self.checkmarkButton.checked;
}
- (void)setChecked:(BOOL)checked
{
    self.checkmarkButton.checked = checked;
}

@end

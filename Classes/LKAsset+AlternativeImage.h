//
//  LKAsset+AlternativeImage.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/03/31.
//
//

#import <LKAssetsLibrary/LKAssetsLibrary.h>

@interface LKAsset (AlternativeImage)

// MARK: - content
@property (nonatomic, weak, readonly) UIImage* alternativeFullResolustionImage;
@property (nonatomic, weak, readonly) UIImage* alternativeFullScreenImageWithoutOrientation;
@property (nonatomic, weak, readonly) UIImage* alternativeAspectRatioThumbnail;

// MARK: - management
@property (nonatomic, weak) UIImage* alternativeImage;
@property (nonatomic, weak, readonly) UIImage* alternativeScreenImage;
@property (nonatomic, weak, readonly) UIImage* alternativeThumbnailImage;
@property (nonatomic, assign, readonly) BOOL hasAlternativeImage;
@property (nonatomic, assign) BOOL alternativeEnabled;
- (void)removeAlternativeImage;

@end

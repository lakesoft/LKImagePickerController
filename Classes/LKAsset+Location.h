//
//  LKAsset+Location.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/04/09.
//
//

#import <LKAssetsLibrary/LKAssetsLibrary.h>

@interface LKAsset (Location)

// MARK: - content
@property (nonatomic, weak) NSString* placeString;

// MARK: - management
@property (nonatomic, assign, readonly) BOOL hasPlaceString;

- (void)removeLocation;

@end

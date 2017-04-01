//
//  LKAsset+Comment.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/03/31.
//
//

#import "LKAssetsLibrary.h"

@interface LKAsset (Comment)
@property (nonatomic, weak) NSString* commentString;
@property (nonatomic, assign, readonly) BOOL hasComment;
@end

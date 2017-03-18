//
//  LKImagePickerControllerCommentManager.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/03/18.
//
//

#import <Foundation/Foundation.h>

@class LKAsset;

@interface LKImagePickerControllerCommentManager : NSObject
+ (NSString*)filePathForAsset:(LKAsset*)asset;
+ (void)removeAllComments;
@end


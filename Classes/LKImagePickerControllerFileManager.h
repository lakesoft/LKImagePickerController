//
//  LKImagePickerControllerFileManager.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/04/01.
//
//

#import <Foundation/Foundation.h>

@class LKAsset;
@interface LKImagePickerControllerFileManager : NSObject

+ (NSString*)filePathForAsset:(LKAsset*)asset;
+ (void)removeAll;

@end

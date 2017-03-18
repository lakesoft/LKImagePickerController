//
//  LKImagePickerControllerCommentManager.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/03/18.
//
//

#import "LKImagePickerControllerCommentManager.h"
#import "LKImagePickerControllerUtility.h"

#define LK_IMAGE_PICKER_CONTROLLER_COMMENT_MANAGER_PATH @"LKImagePickerController.Comments"

@implementation LKImagePickerControllerCommentManager

+ (void)initialize
{
    if (self == [LKImagePickerControllerCommentManager class]) {
        [self _createDefaultPath];
    }
}


+ (void)removeAllComments
{
    [self _removeDefaultPath];
    [self _createDefaultPath];
}

+ (NSString*)filePathForAsset:(LKAsset*)asset
{
    NSString* assetId = [LKImagePickerControllerUtility getIdForAsset:asset];
    NSString* filePath = [[self _defaultPath] stringByAppendingPathComponent:assetId];
    return filePath;
}


// MARK: - Privates
+ (NSString*)_defaultPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                 NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:LK_IMAGE_PICKER_CONTROLLER_COMMENT_MANAGER_PATH];
}

+ (void)_createDefaultPath
{
    NSError *error = nil;
    [NSFileManager.defaultManager createDirectoryAtPath:self._defaultPath
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

+ (void)_removeDefaultPath
{
    NSError *error = nil;
    [NSFileManager.defaultManager removeItemAtPath:self._defaultPath error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

@end


//
//  LKImagePickerControllerPostedAssetsManager.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2016/09/12.
//  Copyright © 2016年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerMarkedAssetsManager.h"
#import "LKImagePickerControllerUtility.h"
#import "LKAssetsLibrary.h"
//#import <CommonCrypto/CommonDigest.h>

#define LK_IMAGE_PICKER_CONTROLLER_POSTED_ASSETS_MANAGER_PATH @"LKImagePickerController.MarkedAssets"
@implementation LKImagePickerControllerMarkedAssetsManager

+ (void)initialize
{
    if (self == [LKImagePickerControllerMarkedAssetsManager class]) {
        [self _createDefaultPath];
    }
}

+ (BOOL)isMarkedAsset:(LKAsset*)asset
{
    NSString* filePath = [self _filePathForAsset:asset];
    return [NSFileManager.defaultManager fileExistsAtPath:filePath];
}

+ (void)markAssets:(NSArray*)assets
{
    for (LKAsset* asset in assets) {
        NSString* filePath = [self _filePathForAsset:asset];
        [@"" writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
}

+ (void)unmarkAssets:(NSArray*)assets
{
    for (LKAsset* asset in assets) {
        NSString* filePath = [self _filePathForAsset:asset];
        NSError* error = nil;
        [NSFileManager.defaultManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(error);
        }
    }
}

+ (void)unmarkAllAssets
{
    [self _removeDefaultPath];
    [self _createDefaultPath];
}



+ (NSString*)_filePathForAsset:(LKAsset*)asset {
    NSString* assetId = [LKImagePickerControllerUtility getIdForAsset:asset];
    NSString* filePath = [[self _defaultPath] stringByAppendingPathComponent:assetId];
    return filePath;
}

+ (NSString*)_defaultPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                 NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:LK_IMAGE_PICKER_CONTROLLER_POSTED_ASSETS_MANAGER_PATH];
}

+ (void)_createDefaultPath
{
    NSError *error = nil;
    [NSFileManager.defaultManager createDirectoryAtPath:self._defaultPath
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:&error];
    if (error) {
        NSLog(error);
    }
}

+ (void)_removeDefaultPath
{
    NSError *error = nil;
    [NSFileManager.defaultManager removeItemAtPath:self._defaultPath error:&error];
    if (error) {
        NSLog(error);
    }
}


//+ (NSString*)_md5String:(NSString*)string
//{
//    unsigned char result[16];
//    const char* cString = [string UTF8String];
//    
//    CC_MD5(cString, (CC_LONG)strlen(cString), result ); // This is the md5 call
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//}

@end

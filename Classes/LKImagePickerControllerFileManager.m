//
//  LKImagePickerControllerFileManager.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/04/01.
//
//

#import "LKImagePickerControllerFileManager.h"
#import "LKImagePickerControllerUtility.h"

@implementation LKImagePickerControllerFileManager

// MARK: - Publics
+ (void)initialize
{
    if (self != [LKImagePickerControllerFileManager class]) {
        [self _createDefaultPath];
    }
}

+ (void)removeAll
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

// MARK: - Overriddens
+ (NSString*)path
{
    return nil; // not called
}

// MARK: - Privates
+ (NSString*)_defaultPath
{
    static NSMutableDictionary* _paths = nil;
    if (_paths == nil) {
        _paths = NSMutableDictionary.new;
    }
    NSString* path = [_paths objectForKey:self];
    
    if (path == nil) {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                     NSUserDomainMask, YES) lastObject]
                stringByAppendingPathComponent:self.path];
        [_paths setObject:path forKey:self];
    }
    return path;
}

+ (void)_createDefaultPath
{
    NSError *error = nil;
    [NSFileManager.defaultManager createDirectoryAtPath:self._defaultPath
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:&error];
    if (error) {
        NSLog(@"[ERROR] Failed to create folder (%@): %@", self, error);
    }
}

+ (void)_removeDefaultPath
{
    NSError *error = nil;
    [NSFileManager.defaultManager removeItemAtPath:self._defaultPath error:&error];
    if (error) {
        NSLog(@"[ERROR] Failed to remove folder (%@): %@", self, error);
    }
}


@end

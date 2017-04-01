//
//  LKAsset+Comment.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/03/31.
//
//

#import "LKAsset+Comment.h"
#import "LKImagePickerControllerCommentManager.h"

@implementation LKAsset (Comment)
- (NSString*)commentString
{
    NSString* filePath = [LKImagePickerControllerCommentManager filePathForAsset:self];
    NSString* str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return str;
}
- (void)setCommentString:(NSString*)commentString
{
    NSString* filePath = [LKImagePickerControllerCommentManager filePathForAsset:self];
    if (commentString == nil || commentString.length == 0) {
        [NSFileManager.defaultManager removeItemAtPath:filePath error:nil];
    } else {
        [commentString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding
                             error:nil];
    }
}

- (BOOL)hasComment
{
    NSString* filePath = [LKImagePickerControllerCommentManager filePathForAsset:self];
    return [NSFileManager.defaultManager fileExistsAtPath:filePath];
}
@end

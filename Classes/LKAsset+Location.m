//
//  LKAsset+Location.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/04/09.
//
//

#import "LKAsset+Location.h"
#import "LKImagePickerControllerLocationManager.h"

@implementation LKAsset (Location)

// MARK: - management (privates)

- (NSString*)_locationFilePath
{
    return [[LKImagePickerControllerLocationManager filePathForAsset:self] stringByAppendingPathExtension:@"txt"];
}

// MARK: - properties (content)
- (NSString*)placeString {
    if (self.hasPlaceString) {
        return [NSString stringWithContentsOfFile:self._locationFilePath encoding:NSUTF8StringEncoding error:nil];
    }
    if (self.location) {
        [LKImagePickerControllerLocationManager addRequestReverseGeocodingWithAsset:self];
        return @"";
    }
    return @"";
}

- (void)setPlaceString:(NSString *)placeString {
    if (placeString) {
        [placeString writeToFile:self._locationFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

// MARK: - properties (management)
- (BOOL)hasPlaceString {
    return [NSFileManager.defaultManager fileExistsAtPath:self._locationFilePath];
}

@end

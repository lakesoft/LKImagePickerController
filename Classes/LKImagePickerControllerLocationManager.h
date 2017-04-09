//
//  LKImagePickerControllerLocationManager.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/04/09.
//
//

#import "LKImagePickerControllerFileManager.h"
#import <LKAssetsLibrary/LKAssetsLibrary.h>

extern NSString * const LKImagePickerControllerLocationManagerDidFinishReverseGeocoding;

@interface LKImagePickerControllerLocationManager : LKImagePickerControllerFileManager

+ (void)addRequestReverseGeocodingWithAsset:(LKAsset*)asset;

@end

//
//  LKImagePickerControllerUtility.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2016/09/12.
//
//

#import <Foundation/Foundation.h>

@class LKAsset;
@interface LKImagePickerControllerUtility : NSObject

+ (NSString*)formattedDateStringForDate:(NSDate*)date;
+ (NSString*)formattedDateTimeStringForDate:(NSDate*)date;
+ (NSString*)getIdForAsset:(LKAsset*)asset;

+ (CAGradientLayer*)setupPlateView:(UIView*)view directionDown:(BOOL)down magnitude:(CGFloat)magnitude;
+ (CAGradientLayer*)setupPlateView:(UIView*)view directionDown:(BOOL)down;

@end

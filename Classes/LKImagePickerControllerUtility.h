//
//  LKImagePickerControllerUtility.h
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2016/09/12.
//
//

#import <Foundation/Foundation.h>

@interface LKImagePickerControllerUtility : NSObject

+ (NSString*)formattedDateStringForDate:(NSDate*)date;
+ (NSString*)formattedDateTimeStringForDate:(NSDate*)date;

@end

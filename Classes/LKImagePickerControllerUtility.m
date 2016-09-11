//
//  LKImagePickerControllerUtility.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2016/09/12.
//
//

#import "LKImagePickerControllerUtility.h"

@implementation LKImagePickerControllerUtility

+ (NSString*)formattedDateStringForDate:(NSDate*)date
{
    NSDateFormatter* formatter1 = NSDateFormatter.new;
    formatter1.dateStyle = NSDateFormatterMediumStyle;
    NSString* dateString1 = [formatter1 stringFromDate:date];
    
    NSDateFormatter* formatter2 = NSDateFormatter.new;
    formatter2.dateFormat = @"E";
    NSString* dateString2 = [formatter2 stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@ %@", dateString1, dateString2];
}

+ (NSString*)formattedDateTimeStringForDate:(NSDate*)date
{
    NSDateFormatter* formatter1 = NSDateFormatter.new;
    formatter1.dateStyle = NSDateFormatterMediumStyle;
    formatter1.timeStyle = NSDateFormatterShortStyle;
    NSString* dateString1 = [formatter1 stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@", dateString1];
}

@end

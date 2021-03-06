//
//  LKImagePickerControllerUtility.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2016/09/12.
//
//

#import "LKImagePickerControllerUtility.h"
#import "LKAssetsLibrary.h"

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

+ (NSString*)getIdForAsset:(LKAsset*)asset
{
    NSArray* pairs = [asset.url.query componentsSeparatedByString:@"&"];
    for (NSString* pair in pairs) {
        NSArray* comp = [pair componentsSeparatedByString:@"="];
        if (comp.count > 1) {
            NSString* key = [[comp firstObject] stringByRemovingPercentEncoding];
            if ([key isEqualToString:@"id"]) {
                return [[comp lastObject] stringByRemovingPercentEncoding];
            }
        }
    }
    return NULL;
}

+ (CAGradientLayer*)setupPlateView:(UIView*)view directionDown:(BOOL)down magnitude:(CGFloat)magnitude
{
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    NSArray* locations;
    
    if (down) {
        locations = [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:0.0],
                     [NSNumber numberWithFloat:0.25],
                     [NSNumber numberWithFloat:0.5],
                     [NSNumber numberWithFloat:1.0],
                     nil];
    } else {
        locations = [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:0.0],
                     [NSNumber numberWithFloat:0.5],
                     [NSNumber numberWithFloat:0.75],
                     [NSNumber numberWithFloat:1.0],
                     nil];
    }
    
    NSArray* colors;
    CGFloat s = magnitude;
    if (down) {
        colors = [NSArray arrayWithObjects:
                  (id)[UIColor colorWithWhite:0.0 alpha:0.3*s].CGColor,
                  (id)[UIColor colorWithWhite:0.0 alpha:0.2*s].CGColor,
                  (id)[UIColor colorWithWhite:0.0 alpha:0.1*s].CGColor,
                  (id)[UIColor clearColor].CGColor,
                  nil];
    } else {
        colors = [NSArray arrayWithObjects:
                  (id)[UIColor clearColor].CGColor,
                  (id)[UIColor colorWithWhite:0.0 alpha:0.1*s].CGColor,
                  (id)[UIColor colorWithWhite:0.0 alpha:0.2*s].CGColor,
                  (id)[UIColor colorWithWhite:0.0 alpha:0.3*s].CGColor,
                  nil];
    }
    gradientLayer.locations = locations;
    gradientLayer.colors = colors;
    [view.layer addSublayer:gradientLayer];
    return gradientLayer;
    
}
+ (CAGradientLayer*)setupPlateView:(UIView*)view directionDown:(BOOL)down
{
    return [self setupPlateView:view directionDown:down magnitude:1.0];
}

@end

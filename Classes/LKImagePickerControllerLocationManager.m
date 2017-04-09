//
//  LKImagePickerControllerLocationManager.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/04/09.
//
//
@import CoreLocation;
//@import AddressBookUI;
#import "LKImagePickerControllerLocationManager.h"
#import "LKAsset+Location.h"

@implementation LKImagePickerControllerLocationManager

NSString * const LKImagePickerControllerLocationManagerDidFinishReverseGeocoding = @"LKImagePickerControllerLocationManagerDidFinishReverseGeocoding";


+ (NSString*)path
{
    return @"LKImagePickerController.Locations";
}

+ (void)addRequestReverseGeocodingWithAsset:(LKAsset*)asset
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    CLGeocoder* geocoder = CLGeocoder.new;
        [geocoder reverseGeocodeLocation:asset.location
                       completionHandler:^(NSArray* placemarks, NSError* error) {
                           NSString* addressString = nil;
                           //                       NSMutableDictionary* addressDictionary = @[].mutableCopy;
                           if (error) {
                               NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
                           } else {
                               CLPlacemark* placemark = [placemarks objectAtIndex:0];
                               NSDictionary* dict = placemark.addressDictionary;
                               //                           if (dict[@"City"]) {
                               //                               addressDictionary[@"City"] = dict[@"City"];
                               //                           }
                               //                           if (dict[@"City"]) {
                               //                               addressDictionary[@"City"] = dict[@"City"];
                               //                           }
                               /*
                                City = "\U3055\U3044\U305f\U307e\U5e02\U4e2d\U592e\U533a";
                                Country = "\U65e5\U672c";
                                CountryCode = JP;
                                FormattedAddressLines =     (
                                "\U3012338-0012",
                                "\U57fc\U7389\U770c\U3055\U3044\U305f\U307e\U5e02\U4e2d\U592e\U533a",
                                "\U5927\U62386\U4e01\U76ee21\U756a"
                                );
                                Name = "\U5927\U62386\U4e01\U76ee21\U756a";
                                State = "\U57fc\U7389\U770c";
                                Street = "\U5927\U62386\U4e01\U76ee21\U756a";
                                SubLocality = "\U5927\U6238";
                                SubThoroughfare = "21\U756a";
                                Thoroughfare = "\U5927\U62386\U4e01\U76ee";
                                ZIP = "338-0012";
                                */
                               //                           NSString* placeString = ABCreateStringWithAddressDictionary(addressDictionary, NO);
                               //                           asset.placeString = [placeString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                               if (dict[@"City"]) {
                                   asset.placeString = dict[@"City"];
                               }
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerLocationManagerDidFinishReverseGeocoding object:asset];
                               });
                           }
                       }];
    });
}


@end

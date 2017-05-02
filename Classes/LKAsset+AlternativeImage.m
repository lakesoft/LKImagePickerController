//
//  LKAsset+AlternativeImage.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2017/03/31.
//
//

#import "LKAsset+AlternativeImage.h"
#import "LKImagePickerControllerAlternateImageManager.h"
#import "LKImagePickerControllerImageUtility.h"

@implementation LKAsset (AlternativeImage)

// MARK: - content (privates)


// MARK: - content

- (UIImage*)alternativeFullResolustionImage
{
    if (self.hasAlternativeImage) {
        return self.alternativeImage;
    } else {
        return self.fullResolutionImage;
    }
}

- (UIImage*)alternativeFullScreenImageWithoutOrientation
{
    if (self.hasAlternativeImage) {
        return self.alternativeScreenImage;
    } else {
        return self.fullScreenImageWithoutOrientation;
    }
}

- (UIImage*)alternativeAspectRatioThumbnail
{
    if (self.hasAlternativeImage) {
        return self.alternativeThumbnailImage;
    } else {
        return self.aspectRatioThumbnail;
    }
}


// MARK: - management (privates)

- (NSString*)_alternativeImageFilePath
{
    return [[LKImagePickerControllerAlternateImageManager filePathForAsset:self] stringByAppendingPathExtension:@"jpg"];
}
- (NSString*)_alternativeImageFilePathForScreen
{
    return [[[LKImagePickerControllerAlternateImageManager filePathForAsset:self] stringByAppendingString:@"_screen"] stringByAppendingPathExtension:@"jpg"];
}
- (NSString*)_alternativeImageFilePathForThumbnail
{
    return [[[LKImagePickerControllerAlternateImageManager filePathForAsset:self] stringByAppendingString:@"_thumbnail"] stringByAppendingPathExtension:@"jpg"];
}
- (NSString*)_alternativeImageFilePathForEnabled
{
    return [[LKImagePickerControllerAlternateImageManager filePathForAsset:self] stringByAppendingPathExtension:@"enabled"];
}

- (void)_removeImageAtFilePath:(NSString*)filePath
{
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        NSError* error = nil;
        [NSFileManager.defaultManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"Failed to remove image (%@): %@", self, error);
        }
    }
}

// MARK: - management (properties)

- (UIImage*)alternativeImage
{
    UIImage* image = [UIImage imageWithContentsOfFile:self._alternativeImageFilePath];
    if (image == nil) {
        NSLog(@"[WARN] Not found the alternative image (%@).", self);
    }
    return image;
}

- (void)setAlternativeImage:(UIImage*)image
{
    if ([UIImageJPEGRepresentation(image, 0.7) writeToFile:self._alternativeImageFilePath atomically:YES]) {
        NSLog(@"[DEBUG] Saved alternative image: %@", NSStringFromCGSize(image.size));
        
        UIImage* screenImage = [self _setAlternativeScreenImage:image];
        if (screenImage) {
            [self _setAlternativeThumbnailImage:screenImage];
        }
    } else {
        NSLog(@"[ERROR] Failed to write alternative image (%@).", self);
    }
}

- (UIImage*)alternativeScreenImage
{
    UIImage* image = [UIImage imageWithContentsOfFile:self._alternativeImageFilePathForScreen];
    if (image == nil) {
        NSLog(@"[WARN] Not found the alternative screen image (%@).", self);
    }
    return image;
}

- (UIImage*)_setAlternativeScreenImage:(UIImage*)image
{
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat width = fmax(size.width, size.height) * UIScreen.mainScreen.scale;
    UIImage* processedImage = [LKImagePickerControllerImageUtility adjustOrientationImage:image toWidth:width];
    if ([UIImageJPEGRepresentation(processedImage, 0.7) writeToFile:self._alternativeImageFilePathForScreen atomically:YES]) {
        NSLog(@"[DEBUG] Saved alternative screen image: %@", NSStringFromCGSize(processedImage.size));
        
        return processedImage;
        
    } else {
        NSLog(@"[ERROR] Failed to write alternative screen image (%@).", self);
        return nil;
    }
}

- (UIImage*)alternativeThumbnailImage
{
    UIImage* image = [UIImage imageWithContentsOfFile:self._alternativeImageFilePathForThumbnail];
    if (image == nil) {
        NSLog(@"[WARN] Not found the alternative thumbnail image (%@).", self);
    }
    return image;
}

- (UIImage*)_setAlternativeThumbnailImage:(UIImage*)image
{
    CGFloat width = 256 * UIScreen.mainScreen.scale;
    UIImage* processedImage = [LKImagePickerControllerImageUtility adjustOrientationImage:image toWidth:width];
    if ([UIImageJPEGRepresentation(processedImage, 0.7) writeToFile:self._alternativeImageFilePathForThumbnail atomically:YES]) {
        NSLog(@"[DEBUG] Saved alternative thumbnail image: %@", NSStringFromCGSize(processedImage.size));
        
        return processedImage;
        
    } else {
        NSLog(@"[ERROR] Failed to write alternative thumbnail image (%@).", self);
        return nil;
    }
}


- (BOOL)hasAlternativeImage
{
    return [NSFileManager.defaultManager fileExistsAtPath:self._alternativeImageFilePath];
}


// MARK: - properties (enabled)

- (BOOL)alternativeEnabled
{
    return [NSFileManager.defaultManager fileExistsAtPath:self._alternativeImageFilePathForEnabled];
}

- (void)setAlternativeEnabled:(BOOL)enabled
{
    if (enabled) {
        [@"enabled" writeToFile:self._alternativeImageFilePathForEnabled atomically:YES encoding:NSASCIIStringEncoding
                             error:nil];
    } else {
        NSError* error = nil;
        [NSFileManager.defaultManager removeItemAtPath:self._alternativeImageFilePathForEnabled error:&error];
        if (error) {
            NSLog(@"Failed to remove alternative enabled flag (%@): %@", self, error);
        }
    }
}


// MARK: - management (function)

- (void)removeAlternativeImage
{
    [self setAlternativeEnabled:NO];
    [self _removeImageAtFilePath:self._alternativeImageFilePath];
    [self _removeImageAtFilePath:self._alternativeImageFilePathForScreen];
    [self _removeImageAtFilePath:self._alternativeImageFilePathForThumbnail];
}


@end

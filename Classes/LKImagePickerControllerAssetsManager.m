//
//  LKImagePickerControllerAssetsManager.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerAssetsManager.h"
#import "LKImagePickerControllerFilter.h"

NSString * const LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification = @"LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification";

NSString * const LKImagePickerControllerAssetsManagerDidChangeSelectable = @"LKImagePickerControllerAssetsManagerDidChangeSelectable";
NSString * const LKImagePickerControllerAssetsManagerDidChangeSelectableKey = @"LKImagePickerControllerAssetsManagerDidChangeSelectableKey";


NSString * const LKImagePickerControllerAssetsManagerDidSelectNotification = @"LKImagePickerControllerAssetsManagerDidSelectNotification";
NSString * const LKImagePickerControllerAssetsManagerDidDeselectNotification = @"LKImagePickerControllerAssetsManagerDidDeselectNotification";

NSString * const LKImagePickerControllerAssetsManagerDidSelectHeaderNotification = @"LKImagePickerControllerAssetsManagerDidSelectHeaderNotification";
NSString * const LKImagePickerControllerAssetsManagerDidDeSelectHeaderNotification = @"LKImagePickerControllerAssetsManagerDidDeSelectHeaderNotification";

NSString * const LKImagePickerControllerAssetsManagerDidAllDeselectNotification = @"LKImagePickerControllerAssetsManagerDidAllDeselectNotification";

NSString * const LKImagePickerControllerAssetsManagerKeyIndexPaths = @"LKImagePickerControllerAssetsManagerKeyIndexPaths";
NSString * const LKImagePickerControllerAssetsManagerKeyAllSelected = @"LKImagePickerControllerSelectViewControllerAllSelected";
NSString * const LKImagePickerControllerAssetsManagerKeyNumberOfSelections = @"LKImagePickerControllerAssetsManagerKeyNumberOfSelections";


@interface LKImagePickerControllerAssetsManager()
@property (strong, nonatomic) LKAssetsLibrary* assetsLibrary;
@property (strong, nonatomic) LKAssetsGroup* assetsGroup;
@property (strong, nonatomic) LKImagePickerControllerFilter* filter;

@property (nonatomic, copy) LKImagePickerControllerAssetsManagerReloadAssetsCompletion reloadAssetsCompletion;
@end

@implementation LKImagePickerControllerAssetsManager

#pragma mark - Privates (LKAssetsLibrary)
- (void)_assetsLibraryDidSetup:(NSNotification*)notification
{
    for (LKAssetsGroup* assetsGroup in self.assetsLibrary.assetsGroups) {
        if (assetsGroup.type == ALAssetsGroupSavedPhotos) {
            self.assetsGroup = assetsGroup;
            break;
        }
    }
    // safty guard
    if (self.assetsGroup == nil) {
        self.assetsGroup = self.assetsLibrary.assetsGroups.firstObject;
    }
    
    if (self.reloadAssetsCompletion) {
        self.reloadAssetsCompletion();
        self.reloadAssetsCompletion = nil;
    }
}

- (void)_assetsGroupDidReload:(NSNotification*)notification
{
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification object:self];
}

- (void)_assetsLibraryDidInsertGroup:(NSNotification*)notification
{
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification object:self];
}

- (void)_assetsLibraryDidUpdateGroup:(NSNotification*)notification
{
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification object:self];
}

- (void)_assetsLibraryDidDeleteGroup:(NSNotification*)notification
{
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification object:self];
}

#pragma mark - Privates (Selection/Deselection)
- (void)_didChangeSelection:(NSNotification*)notification
{
    NSInteger numberOfSelections = ((NSNumber*)notification.userInfo[LKImagePickerControllerAssetsManagerKeyNumberOfSelections]).integerValue;
    if (self.maximumOfSelections) {
        BOOL newSelectable = numberOfSelections < self.maximumOfSelections;
        if (newSelectable != self.selectable) {
            NSDictionary* userInfo = @{LKImagePickerControllerAssetsManagerDidChangeSelectableKey:@(newSelectable)};
            [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerAssetsManagerDidChangeSelectable
                                                              object:self
                                                            userInfo:userInfo];
            self.selectable = newSelectable;
        }
    }
}

#pragma mark - Basics
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedAssets = [NSMutableOrderedSet orderedSet];

        self.assetsLibrary = [LKAssetsLibrary assetsLibrary];
        self.selectable = YES;

        NSNotificationCenter* nc = NSNotificationCenter.defaultCenter;

        // Notifications (LKAssetsLibrary)
        [nc addObserver:self
               selector:@selector(_assetsLibraryDidSetup:)
                   name:LKAssetsLibraryDidSetupNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_assetsGroupDidReload:)
                   name:LKAssetsGroupDidReloadNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_assetsLibraryDidInsertGroup:)
                   name:LKAssetsLibraryDidInsertGroupsNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_assetsLibraryDidUpdateGroup:)
                   name:LKAssetsLibraryDidUpdateGroupsNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_assetsLibraryDidDeleteGroup:)
                   name:LKAssetsLibraryDidDeleteGroupsNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_assetsLibraryDidDeleteGroup:)
                   name:LKAssetsLibraryDidDeleteGroupsNotification
                 object:nil];

        // Notifications (Select/Deselect)
        [nc addObserver:self
               selector:@selector(_didChangeSelection:)
                   name:LKImagePickerControllerAssetsManagerDidSelectNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_didChangeSelection:)
                   name:LKImagePickerControllerAssetsManagerDidDeselectNotification
                 object:nil];

        [nc addObserver:self
               selector:@selector(_didChangeSelection:)
                   name:LKImagePickerControllerAssetsManagerDidSelectHeaderNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_didChangeSelection:)
                   name:LKImagePickerControllerAssetsManagerDidDeSelectHeaderNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(_didChangeSelection:)
                   name:LKImagePickerControllerAssetsManagerDidAllDeselectNotification
                 object:nil];

        // filter
        self.filter = LKImagePickerControllerFilter.new;
    }
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

+ (instancetype)assetsManager
{
    return self.new;
}

- (NSInteger)numberOfSelected
{
    return self.selectedAssets.count;
}
- (BOOL)reachedMaximumOfSelections
{
    return self.maximumOfSelections <= self.selectedAssets.count;
}

#pragma mark - API
- (void)reloadAssetsWithCompletion:(LKImagePickerControllerAssetsManagerReloadAssetsCompletion)completion
{
    self.reloadAssetsCompletion = completion;
    [self.assetsLibrary reload];
}

- (void)reloadAssetsGroup
{
    [self.assetsGroup reloadAssets];
}

- (void)setAndReloadAssetsGroup:(LKAssetsGroup*)assetsGroup
{
    self.assetsGroup = assetsGroup;
    [self.assetsGroup reloadAssets];
}

@end

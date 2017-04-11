//
//  LKImagePickerControllerAssetsManager.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerAssetsManager.h"
#import "LKImagePickerControllerFilter.h"
#import "LKImagePickerController.h"

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
@property (strong, nonatomic) NSMutableOrderedSet* selectedAssets;  // <LKAssets>

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

- (void)_notify
{
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification object:self];
}

- (void)_notifyWithDelay
{
    [LKImagePickerControllerAssetsManager cancelPreviousPerformRequestsWithTarget:self selector:@selector(_notify) object:nil];
    [self performSelector:@selector(_notify) withObject:nil afterDelay:5.0];
}

- (void)_assetsGroupDidReload:(NSNotification*)notification
{
    static BOOL firstFlag = YES;
    
    if (firstFlag) {
        firstFlag = NO;
        [self _notify];
    } else {
        [self _notifyWithDelay];
    }
}

- (void)_assetsLibraryDidInsertGroup:(NSNotification*)notification
{
    [self _notifyWithDelay];
}

- (void)_assetsLibraryDidUpdateGroup:(NSNotification*)notification
{
    // not used to avoid duplicate notify
//    [self _notifyWithDelay];
}

- (void)_assetsLibraryDidDeleteGroup:(NSNotification*)notification
{
    [self _notifyWithDelay];
}

#pragma mark - Privates (Selection/Deselection)
- (void)_didChangeSelection:(NSNotification*)notification
{
    NSInteger numberOfSelections = ((NSNumber*)notification.userInfo[LKImagePickerControllerAssetsManagerKeyNumberOfSelections]).integerValue;
    if (self.maximumOfSelections) {
        NSInteger max = self.maximumOfSelections ? self.maximumOfSelections : NSIntegerMax;
        BOOL newSelectable = numberOfSelections < max;
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

- (instancetype)initWithAvailableTypes:(NSUInteger)availableTypes currentType:(LKImagePickerControllerFilterType)currentType
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
        self.filter = [[LKImagePickerControllerFilter alloc] initWithAvailableTypes:availableTypes currentType:currentType];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithAvailableTypes:LKImagePickerControllerFilterTypeAll currentType:LKImagePickerControllerFilterTypeAll];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

+ (instancetype)assetsManager
{
    return self.new;
}

+ (instancetype)assetsManagerWithAvaliableTypes:(NSUInteger)availableTypes currentType:(LKImagePickerControllerFilterType)currentType
{
    if (availableTypes == 0) {
        availableTypes = LKImagePickerControllerFilterTypeAll;
    }
    if (currentType == 0) {
        currentType = LKImagePickerControllerFilterTypeAll;
    }
    return [[self alloc] initWithAvailableTypes:availableTypes currentType:currentType];
}


- (NSInteger)numberOfSelected
{
    return self.selectedAssets.count;
}
- (BOOL)reachedMaximumOfSelections
{
    NSInteger max = self.maximumOfSelections ? self.maximumOfSelections : NSIntegerMax;
    return max <= self.selectedAssets.count;
}

#pragma mark - Selection
- (void)selectAsset:(LKAsset*)asset
{
    [self.selectedAssets addObject:asset];
    
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(imagePickerController:selectedAssets:)]) {
        [self.imagePickerController.imagePickerControllerDelegate imagePickerController:self.imagePickerController selectedAssets:@[asset]];
    }
}
- (void)deselectAsset:(LKAsset*)asset
{
    [self.selectedAssets removeObject:asset];

    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(imagePickerController:deselectedAssets:)]) {
        [self.imagePickerController.imagePickerControllerDelegate imagePickerController:self.imagePickerController deselectedAssets:@[asset]];
    }
}
- (BOOL)containsSelectedAsset:(LKAsset*)asset
{
    return [self.selectedAssets containsObject:asset];
}
- (void)removeAllSelectedAssets
{
    NSArray* assets = self.selectedAssets.array.copy;
    [self.selectedAssets removeAllObjects];

    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(imagePickerController:deselectedAssets:)]) {
        [self.imagePickerController.imagePickerControllerDelegate imagePickerController:self.imagePickerController deselectedAssets:assets];
    }
}
- (NSArray*)arrayOfSelectedAssets
{
    return self.selectedAssets.array;
}

- (NSArray*)sortedArrayOfSelectedAssets
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.selectedAssets.array];
    [array sortUsingComparator:^NSComparisonResult(LKAsset* asset1, LKAsset* asset2) {
        return [asset1.date compare:asset2.date];
    }];
    return array;
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

//
//  LKImagePickerControllerAssetsManager.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/26.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerAssetsManager.h"

NSString * const LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification = @"LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification";

@interface LKImagePickerControllerAssetsManager()
@property (strong, nonatomic) LKAssetsLibrary* assetsLibrary;
@property (strong, nonatomic) LKAssetsGroup* assetsGroup;

@property (nonatomic, copy) LKImagePickerControllerAssetsManagerReloadAssetsCompletion reloadAssetsCompletion;
@end

@implementation LKImagePickerControllerAssetsManager

#pragma mark - Privates
- (void)_assetsLibraryDidSetup:(NSNotification*)notification
{
    self.assetsGroup = self.assetsLibrary.assetsGroups[0];

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

#pragma mark - Basics
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.assetsLibrary = [LKAssetsLibrary assetsLibrary];

        // Notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_assetsLibraryDidSetup:)
                                                     name:LKAssetsLibraryDidSetupNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_assetsGroupDidReload:)
                                                     name:LKAssetsGroupDidReloadNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_assetsLibraryDidInsertGroup:)
                                                     name:LKAssetsLibraryDidInsertGroupsNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_assetsLibraryDidUpdateGroup:)
                                                     name:LKAssetsLibraryDidUpdateGroupsNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_assetsLibraryDidDeleteGroup:)
                                                     name:LKAssetsLibraryDidDeleteGroupsNotification
                                                   object:nil];
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

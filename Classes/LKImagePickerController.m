//
//  LKImagePickerController.m
//  TEST
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerController.h"
#import "LKImagePickerControllerAssetsManager.h"
#import "LKImagePickerControllerAppearance.h"
#import "LKImagePickerControllerGroupTableViewController.h"
#import "LKImagePickerControllerSelectViewController.h"

@interface LKImagePickerController ()
@property (strong, nonatomic) LKImagePickerControllerAssetsManager* assetsManager;
@property (weak  , nonatomic) LKImagePickerControllerSelectViewController* selectViewController;
@end

@implementation LKImagePickerController

#pragma mark - Privates
- (void)_didChangeTintColor:(NSNotification*)notification
{
    [UINavigationBar appearance].barTintColor = LKImagePickerControllerAppearance.sharedAppearance.navigationBarColor;
    [UINavigationBar appearance].tintColor = LKImagePickerControllerAppearance.sharedAppearance.foregroundColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

#pragma mark - Basics

- (instancetype)initWithAvaliableTypes:(NSUInteger)availableTypes currentType:(LKImagePickerControllerFilterType)currentType
{
    self = [super init];
    if (self) {
        _availableTypes = availableTypes;
        _currentType = currentType;
//        self.view.backgroundColor = UIColor.whiteColor;
        self.assetsManager = [LKImagePickerControllerAssetsManager assetsManagerWithAvaliableTypes:self.availableTypes currentType:self.currentType];
        self.assetsManager.imagePickerController = self;
        

    }
    return self;
}
- (instancetype)init
{
    return [self initWithAvaliableTypes:LKImagePickerControllerFilterTypeAll currentType:LKImagePickerControllerFilterTypeAll];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)setCurrentType:(LKImagePickerControllerFilterType)currentType
{
    // TODO: change current type of filter
    _currentType = currentType;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _didChangeTintColor:nil];
    
    [self.assetsManager reloadAssetsWithCompletion:^{
        LKImagePickerControllerSelectViewController* viewController = LKImagePickerControllerSelectViewController.new;
        viewController.imagePickerController = self;
        viewController.assetsManager = self.assetsManager;
        [self pushViewController:viewController animated:NO];
        self.selectViewController = viewController;
    }];
    
    NSNotificationCenter* nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self selector:@selector(_didChangeTintColor:) name:LKImagePickerControllerAppearanceDidChangeTintColorNotification object:nil];

    for (NSString* name in @[LKImagePickerControllerAssetsManagerDidSelectNotification,
                             LKImagePickerControllerAssetsManagerDidDeselectNotification,
                             LKImagePickerControllerAssetsManagerDidSelectHeaderNotification,
                             LKImagePickerControllerAssetsManagerDidDeSelectHeaderNotification,
                             LKImagePickerControllerAssetsManagerDidAllDeselectNotification,
                             ]) {
        [nc addObserver:self selector:@selector(_didUpdateSelections:) name:name object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    LKImagePickerControllerAppearance.sharedAppearance.tintColor = tintColor;
}

- (void)setMaximumOfSelections:(NSInteger)maximumOfSelections
{
    _maximumOfSelections = maximumOfSelections;
    self.assetsManager.maximumOfSelections = maximumOfSelections;
}

- (void)deselectAll
{
    [self.selectViewController deselectAll];
}

- (void)displayMainScreenAnimated:(BOOL)animated
{
    [self.selectViewController displayMainScreenAnimated:animated];
    [self popToRootViewControllerAnimated:animated];
}

- (NSArray*)selectedAssets
{
    BOOL sortBySelectionOrder = NO;
    if ([self.imagePickerControllerDelegate respondsToSelector:@selector(sortBySelectionOrder)]) {
        sortBySelectionOrder = [self.imagePickerControllerDelegate sortBySelectionOrder];
    }
    if (sortBySelectionOrder) {
        return self.assetsManager.arrayOfSelectedAssets;
    } else {
        return self.assetsManager.sortedArrayOfSelectedAssets;
    }
}

- (void)_didUpdateSelections:(NSNotification*)notification
{
    if ([self.imagePickerControllerDelegate respondsToSelector:@selector(didUpdateSelections:)]) {
        [self.imagePickerControllerDelegate didUpdateSelections:self.selectedAssets.count];
    }
}


@end

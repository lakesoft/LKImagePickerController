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

#pragma mark - Basics

- (instancetype)initWithAvaliableTypes:(NSUInteger)availableTypes currentType:(LKImagePickerControllerFilterType)currentType
{
    self = [super init];
    if (self) {
        _availableTypes = availableTypes;
        _currentType = currentType;
        self.toolBarHidden = NO;
//        self.view.backgroundColor = UIColor.whiteColor;
        

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
    
    self.navigationBar.barTintColor = LKImagePickerControllerAppearance.sharedAppearance.navigationBarColor;
    self.navigationBar.tintColor = LKImagePickerControllerAppearance.sharedAppearance.navigationFontColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: LKImagePickerControllerAppearance.sharedAppearance.navigationFontColor};
    
    self.assetsManager = [LKImagePickerControllerAssetsManager assetsManagerWithAvaliableTypes:self.availableTypes currentType:self.currentType];
    self.assetsManager.imagePickerController = self;

    [self.assetsManager reloadAssetsWithCompletion:^{
        LKImagePickerControllerSelectViewController* viewController = LKImagePickerControllerSelectViewController.new;
        viewController.imagePickerController = self;
        viewController.assetsManager = self.assetsManager;
        [self pushViewController:viewController animated:NO];
        self.selectViewController = viewController;
    }];
    self.maximumOfSelections = self.maximumOfSelections;    // reuired
    
    NSNotificationCenter* nc = NSNotificationCenter.defaultCenter;

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

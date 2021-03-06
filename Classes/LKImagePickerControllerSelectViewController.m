
//
//  LKImagePickerControllerSelectViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
#import "LKImagePickerController.h"
#import "LKImagePickerControllerSelectViewController.h"
#import "LKImagePickerControllerSelectCell.h"
#import "LKImagePickerControllerSelectHeaderView.h"
#import "LKImagePickerControllerAppearance.h"
#import "LKImagePickerControllerDetailViewController.h"
#import "LKImagePickerControllerGroupTableViewController.h"
#import "LKImagePickerControllerSelectionButton.h"
#import "LKImagePickerControllerFilterSelectionViewController.h"
#import "LKImagePickerControllerFilter.h"
#import "LKImagePickerControllerBundleManager.h"
#import "LKImagePickerControllerCheckmarkButton.h"
#import "LKImagePickerControllerCloseButton.h"
#import "LKImagePickerControllerEmptyView.h"
#import "LKImagePickerControllerNavigationController.h"

NS_ENUM(NSInteger, LKImagePickerControllerSelectViewSheet) {
    LKImagePickerControllerSelectViewSheetResetSelections,
    LKImagePickerControllerSelectViewSheetLoseSelections,
};

#define LK_IMAGE_PICKER_CONTROLLER_SPACHE   @"        "

@interface LKImagePickerControllerSelectViewController () <UIActionSheetDelegate>

#pragma mark - Views
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark - LKAasetsLibrary
@property (nonatomic, strong) LKAssetsCollection* assetsCollection;
@property (nonatomic, assign) LKAssetsCollectionGenericGroupingType groupingType;

#pragma mark - Controls
@property (nonatomic, weak) LKImagePickerControllerSelectionButton* selectionButton;
@property (nonatomic, weak) LKImagePickerControllerCheckmarkButton* checkButton;
@property (nonatomic, strong) UIBarButtonItem* doneItem;
@property (nonatomic, strong) UIBarButtonItem* cancelItem;
@property (nonatomic, strong) UIBarButtonItem* clearItem;
@property (nonatomic, strong) UIBarButtonItem* filterItem;
//@property (nonatomic, strong) UIBarButtonItem* groupItem;
@property (nonatomic, strong) UIBarButtonItem* checkItem;
@property (nonatomic, strong) UIBarButtonItem* buttonItem;
@property (nonatomic, strong) UIBarButtonItem* emptyItem;
@property (nonatomic, weak) LKImagePickerControllerEmptyView* emptyView;
@property (nonatomic, weak) UIButton* titleButton;
//@property (nonatomic, weak) UIView* titleView;
@property (nonatomic, weak) UIImageView* waitIndicatorView;

#pragma mark - Models
@property (nonatomic, assign) BOOL displayingSelectedOnly;
@property (nonatomic, strong) LKAssetsCollection* displayingAssetsCollection;
@property (nonatomic, strong) NSIndexPath* currentIndexPath;
@property (nonatomic, assign) BOOL firstReloadingFinished;

@end

@implementation LKImagePickerControllerSelectViewController

- (void)_alertForFilled
{
    [self.selectionButton warnAboutExceeding];
}

- (void)_clearAlert
{
    self.selectionButton.alerted = NO;
}

- (NSString*)_titleString
{
    return [NSString stringWithFormat:@"%@ ⇣",self.assetsCollection.assetsGroup.name];
}

#pragma mark - Privates (LKAssetsLibrary)
- (void)setDisplayingAssetsCollection:(LKAssetsCollection *)displayingAssetsCollection
{
    _displayingAssetsCollection = displayingAssetsCollection;
    displayingAssetsCollection.filter = [self.assetsManager.filter assetsFilter];
}

- (void)_assetsGroupDidReload:(NSNotification*)notification

{
    BOOL first = !self.firstReloadingFinished;
    self.firstReloadingFinished = YES;

    self.assetsCollection = [self _assetsCollectionWithAssetsGroup:self.assetsManager.assetsGroup orAssets:nil];
    self.displayingAssetsCollection = self.assetsCollection;
    self.displayingSelectedOnly = NO;
    [self _reloadAndSetupSelectionsFirst:first];
    [self.titleButton setTitle:self._titleString forState:UIControlStateNormal];
    self.title = self.assetsCollection.assetsGroup.name;
    [self _updateControls];
    
    if (self.assetsCollection.numberOfAssets == 0) {
        self.emptyView.hidden = NO;
        self.emptyView.alpha = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.emptyView.alpha = 1.0;
        }];
    }
    
    [self.waitIndicatorView stopAnimating];
    
    if (self.detailViewController) {
        self.detailViewController.assetsCollection = self.displayingAssetsCollection;
        [self.detailViewController reloadCollectionViews];
    }
}

- (LKAssetsCollection*)_assetsCollectionWithAssetsGroup:(LKAssetsGroup*)assetsGroup orAssets:(NSArray*)orAssets
{
    if (self.groupingType == 0) {
        self.groupingType = LKAssetsCollectionGenericGroupingTypeDaily;
    }
    
    LKAssetsCollectionGenericGrouping* grouping = [LKAssetsCollectionGenericGrouping groupingWithType:self.groupingType];
    
    LKAssetsCollection* assetsCollection;
    if (assetsGroup) {
        assetsCollection = [LKAssetsCollection assetsCollectionWithGroup:assetsGroup grouping:grouping];
    } else {
        assetsCollection = [LKAssetsCollection assetsCollectionWithAssets:orAssets grouping:grouping];
    }
    return assetsCollection;
}

- (void)_postNotificationName:(NSString*)notificationName indexPath:(NSIndexPath*)indexPath
{
    BOOL allSelected = [self _allSelectedInSection:indexPath.section];
    NSDictionary* userInfo = @{LKImagePickerControllerAssetsManagerKeyIndexPaths:@[indexPath],
                               LKImagePickerControllerAssetsManagerKeyAllSelected:@(allSelected),
                               LKImagePickerControllerAssetsManagerKeyNumberOfSelections:@(self.assetsManager.numberOfSelected)};
    [NSNotificationCenter.defaultCenter postNotificationName:notificationName
                                                      object:self
                                                    userInfo:userInfo];
}


#pragma mark - Privates (Selections)
- (BOOL)_allSelectedInSection:(NSInteger)section
{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    if (numberOfItems == 0) {
        return NO;
    }
    BOOL allSelected = YES;
    for (NSInteger item=0; item < numberOfItems; item++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        LKAsset* asset = [self.displayingAssetsCollection assetForIndexPath:indexPath];
        if (![self.assetsManager containsSelectedAsset:asset]) {
            allSelected = NO;
            break;
        }
    }
    return allSelected;
}

- (BOOL)_allSelected
{
    return (self.assetsManager.numberOfSelected == self.displayingAssetsCollection.numberOfAssets);
}

- (void)_reloadAndSetupSelections
{
    [self _reloadAndSetupSelectionsFirst:NO];
}

- (void)_reloadAndSetupSelectionsFirst:(BOOL)first
{
    [self.collectionView reloadData];
    CATransition *animation = [CATransition animation];[animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFillMode:kCAFillModeBoth];[animation setDuration:0.75];
    [self.collectionView.layer addAnimation:animation forKey:@"CATransitionReloadAnimation"];

    if (first) {
        NSInteger lastSection = self.displayingAssetsCollection.entries.count-1;
        if (lastSection >= 0) {
            for (NSInteger section=lastSection; section >= 0; section--) {
                LKAssetsCollectionEntry* entry = self.displayingAssetsCollection.entries[section];
                NSInteger item = entry.assets.count - 1;
                if (item >=0 ) {
                    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:item
                                                                     inSection:section];
                    [self.collectionView scrollToItemAtIndexPath:lastIndexPath
                                                atScrollPosition:UICollectionViewScrollPositionBottom
                                                        animated:NO];
                    break;
                }
            }
        }
    }
}

- (void)_changedSelectable:(NSNotification*)notification
{
    [self _clearAlert];
}

#pragma mark - Privates (Actions)
- (void)_tappedClear:(id)sender
{
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(handleClearSelections:)]) {
        [self.imagePickerController.imagePickerControllerDelegate handleClearSelections:^{
            [self deselectAll];
        }];
    } else {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Selection.DeselectAll"]
                                                           delegate:self
                                                  cancelButtonTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.Cancel"]
                                             destructiveButtonTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.OK"]                                              otherButtonTitles:nil];
        sheet.tag = LKImagePickerControllerSelectViewSheetResetSelections;
        [sheet showFromToolbar:self.navigationController.toolbar];
    }
}

- (void)_selectAllItems
{
    for (NSInteger section=0; section < self.displayingAssetsCollection.entries.count; section++) {
        LKAssetsCollectionEntry* entry = self.displayingAssetsCollection.entries[section];
        for (NSInteger item=0; item < entry.assets.count; item++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            LKAsset* asset = entry.assets[item];
            [self.assetsManager selectAsset:asset];
            [self _postNotificationName:LKImagePickerControllerAssetsManagerDidSelectNotification
                              indexPath:indexPath];
        }
    }
    [self _updateControls];
    [self.collectionView reloadData];
}

- (void)_tappedCheckbutton:(id)sender
{
    if (self.assetsManager.numberOfSelected > 0) {
        [self deselectAll];
    } else {
        [self _selectAllItems];
    }
}

- (void)_tappedSelectionNumber:(id)sender
{
    self.displayingSelectedOnly = !self.displayingSelectedOnly;
}

- (void)_tappedDone:(id)sender
{
    [self.imagePickerController.imagePickerControllerDelegate imagePickerController:self.imagePickerController
                                                                didFinishWithAssets:self.imagePickerController.selectedAssets];

    self.displayingSelectedOnly = NO;
    
    BOOL closeWhenFinish = YES;
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(closeWhenFinish)]) {
        closeWhenFinish = [self.imagePickerController.imagePickerControllerDelegate closeWhenFinish];
    }
    if (closeWhenFinish) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)tappedHeader:(UIButton*)sender
{
    LKImagePickerControllerSelectHeaderView* headerView = (LKImagePickerControllerSelectHeaderView*)sender.superview;
    NSInteger section = headerView.section;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    
    BOOL allSelected = [self _allSelectedInSection:section];
    BOOL nextAllSelected = !allSelected;

    NSMutableArray* indexPaths = @[].mutableCopy;
    NSInteger max = self.assetsManager.maximumOfSelections ? self.assetsManager.maximumOfSelections : NSIntegerMax;

    NSInteger rest = max - self.assetsManager.numberOfSelected;
    
    for (NSInteger item=0; item < numberOfItems; item++) {
        if (nextAllSelected && rest <= 0) {
            break;
        }
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        LKAsset* asset = [self.displayingAssetsCollection assetForIndexPath:indexPath];
        [indexPaths addObject:indexPath];

        LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
        if (nextAllSelected) {
            [self.assetsManager selectAsset:asset];
            cell.checked = YES;
        rest--;
            
        } else {
            [self.assetsManager deselectAsset:asset];
            cell.checked = NO;
        }
    }
    
    NSString* notificationName = nextAllSelected ?  LKImagePickerControllerAssetsManagerDidSelectHeaderNotification : LKImagePickerControllerAssetsManagerDidDeSelectHeaderNotification;

    NSDictionary* userInfo = @{LKImagePickerControllerAssetsManagerKeyIndexPaths:indexPaths,
                               LKImagePickerControllerAssetsManagerKeyAllSelected:@(allSelected),
                               LKImagePickerControllerAssetsManagerKeyNumberOfSelections:@(self.assetsManager.numberOfSelected)};
    [NSNotificationCenter.defaultCenter postNotificationName:notificationName
                                                      object:self
                                                    userInfo:userInfo];

    // must be [1]
    [self _updateControls];

    // must be [2]
    if (rest <= 0 && indexPaths.count < numberOfItems) {
        [self _alertForFilled];
    } else {
        headerView.allSelected = nextAllSelected;
    }
}

- (void)_tappedCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)_tappedGroup:(id)sender
{
    if (self.assetsManager.numberOfSelected > 0) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Selection.ChangeGroup"]
                                                           delegate:self
                                                  cancelButtonTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.Cancel"]
                                             destructiveButtonTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.OK"]
                                                  otherButtonTitles:nil];
        sheet.tag = LKImagePickerControllerSelectViewSheetLoseSelections;
        [sheet showFromToolbar:self.navigationController.toolbar];
    } else {
        [self _openGroupView];
    }
}
- (void)_tappedFilter:(id)sender
{
    [self _openFilterView];
}

- (void)_setupBarButtonItem
{
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(rightBarButtonItems)]) {
        self.navigationItem.rightBarButtonItems = self.imagePickerController.imagePickerControllerDelegate.rightBarButtonItems;
    } else if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(rightBarButtonItem)]) {
        self.navigationItem.rightBarButtonItem = self.imagePickerController.imagePickerControllerDelegate.rightBarButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = self.doneItem;
    }
    
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(leftBarButtonItems)]) {
        self.navigationItem.leftBarButtonItems = self.imagePickerController.imagePickerControllerDelegate.leftBarButtonItems;
    } else if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(leftBarButtonItem)]) {
        self.navigationItem.leftBarButtonItem = self.imagePickerController.imagePickerControllerDelegate.leftBarButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = self.cancelItem;
    }
}


#pragma mark - Privates (Presentations)
- (void)_updateControls
{
    self.selectionButton.numberOfSelections = self.assetsManager.numberOfSelected;
    self.selectionButton.active = self.displayingSelectedOnly;
    BOOL enabled = self.assetsManager.numberOfSelected > 0;
    
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(enableCompletionButtonWhenNoSelections)]) {
        if (self.imagePickerController.imagePickerControllerDelegate.enableCompletionButtonWhenNoSelections) {
            self.doneItem.enabled = YES;
        } else {
            self.doneItem.enabled = enabled;
        }
    } else {
        self.doneItem.enabled = enabled;
    }
    
    self.clearItem.enabled = enabled;

    if (self.displayingSelectedOnly) {
        if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(disableRightBarButtonItem2WhenNoSelected)]) {
            if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(rightBarButtonItem2)]) {
                self.navigationItem.rightBarButtonItem.enabled = enabled;
            }
        }
    } else {
        if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(disableRightBarButtonItemWhenNoSelected)]) {
            if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(rightBarButtonItem)]) {
                self.navigationItem.rightBarButtonItem.enabled = enabled;
            }
        }
    }
    
    
    self.filterItem.title = self.displayingSelectedOnly ? LK_IMAGE_PICKER_CONTROLLER_SPACHE : self.assetsManager.filter.description;
    self.checkButton.checked = enabled && self._allSelected;
    
    BOOL emptyCollection = (self.displayingAssetsCollection.numberOfAssets == 0);
    self.emptyView.hidden = !(emptyCollection && self.firstReloadingFinished);
    self.emptyView.text = [LKImagePickerControllerBundleManager localizedStringForKey:self.displayingSelectedOnly ? @"Common.NoSelections" : @"Common.NoPics"];
    
}


#pragma mark - Privates (Navigations)
- (void)_openGroupView
{
    [self _clearAlert];

    LKImagePickerControllerGroupTableViewController* viewController = LKImagePickerControllerGroupTableViewController.new;
    viewController.assetsManager = self.assetsManager;
    viewController.selectViewController = self;
    LKImagePickerControllerNavigationController* navigationController = [[LKImagePickerControllerNavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)_openFilterView
{
    [self _clearAlert];

    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(openFilterMenuWithDescriptions:currentIndex:completion:)]) {
        NSMutableArray* descriptions = @[].mutableCopy;
        for (int index=0; index < self.assetsManager.filter.filterTypes.count; index++) {
            LKImagePickerControllerFilterType type = [self.assetsManager.filter typeAtIndex:index];
            [descriptions addObject:[self.assetsManager.filter descriptionForType:type]];
        }
        [self.imagePickerController.imagePickerControllerDelegate openFilterMenuWithDescriptions:descriptions currentIndex:self.assetsManager.filter.currentIndex completion:^(int index) {
            if (index >= 0) {
                LKImagePickerControllerFilterType filterType = [self.assetsManager.filter typeAtIndex:index];
                if (filterType != self.assetsManager.filter.currentType) {
                    self.assetsManager.filter.currentType = filterType;
                    [self didChangeFilterType];
                }
            }
        }];
    } else {
        LKImagePickerControllerFilterSelectionViewController* viewController = LKImagePickerControllerFilterSelectionViewController.new;
        viewController.assetsManager = self.assetsManager;
        viewController.selectViewController = self;
        LKImagePickerControllerNavigationController* navigationController = [[LKImagePickerControllerNavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)_openDetailViewAtIndexPath:(NSIndexPath*)indexPath
{
    [self _clearAlert];

    LKImagePickerControllerDetailViewController* viewController = LKImagePickerControllerDetailViewController.new;
    viewController.assetsCollection = self.displayingAssetsCollection;
    viewController.indexPath = indexPath;
    viewController.assetsManager = self.assetsManager;
    viewController.selectViewController = self;
    viewController.navigatioBarHidden = self.imagePickerController.navigationBarHidden;
    
    if (self.imagePickerController.navigationBarHidden) {
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    self.detailViewController = viewController;
}


#pragma mark - Privtates (Gestures)
-(void)_handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath){
        if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(didSelectViewCellLongPressBeganViewController:asset:)]) {
            LKImagePickerControllerSelectCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [cell flashCompletion:^{
                LKAsset* asset = [self.displayingAssetsCollection assetForIndexPath:indexPath];
                [self.imagePickerController.imagePickerControllerDelegate didSelectViewCellLongPressBeganViewController:self asset:asset];
            }];
        }
    }
}

#pragma mark - Basics

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:LKImagePickerControllerBundleManager.bundle];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_assetsGroupDidReload:)
                                               name:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_changedSelectable:)
                                               name:LKImagePickerControllerAssetsManagerDidChangeSelectable
                                             object:nil];
    

    // Setup tint color
    self.navigationController.toolbar.tintColor = LKImagePickerControllerAppearance.sharedAppearance.toolbarFontColor;
    self.navigationController.toolbar.clipsToBounds = true;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithWhite:1.0 alpha:0.75];

    // Bar buttons
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.Back"] style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_tappedCancel:)];
    UIBarButtonItem* clearItem = [[UIBarButtonItem alloc] initWithTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.Clear"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(_tappedClear:)];
    
//    UIBarButtonItem* groupItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(_tappedGroup:)];

    UIBarButtonItem* filterItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(_tappedFilter:)];

    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem* doneItem;
    
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(completionButtonTitle)]) {
        doneItem = [[UIBarButtonItem alloc] initWithTitle:self.imagePickerController.imagePickerControllerDelegate.completionButtonTitle

                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(_tappedDone:)];
    } else {
        doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_tappedDone:)];
    }
    
    self.emptyItem = [[UIBarButtonItem alloc] initWithTitle:LK_IMAGE_PICKER_CONTROLLER_SPACHE style:UIBarButtonItemStylePlain target:nil action:nil];

    LKImagePickerControllerSelectionButton* selectionButton =
    [LKImagePickerControllerSelectionButton selectionButtonTarget:self action:@selector(_tappedSelectionNumber:) assetsManager:self.assetsManager];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:selectionButton];
    buttonItem.width = selectionButton.maxButtonWidth;

    
    UIBarButtonItem* checkItem = nil;
    LKImagePickerControllerCheckmarkButton* checkButton = nil;
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(rightBarButtonItem2)]) {
        checkItem = self.imagePickerController.imagePickerControllerDelegate.rightBarButtonItem2;
    } else {
        checkButton = [LKImagePickerControllerCheckmarkButton checkmarkButtonWithTarget:self action:@selector(_tappedCheckbutton:) size:CGSizeMake(30.0, 30.0)];
        checkButton.hidden = YES;
        checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    }
    
    LKImagePickerControllerCheckmarkButton* dummyButton = [LKImagePickerControllerCheckmarkButton checkmarkButtonWithTarget:nil action:nil size:CGSizeMake(30.0, 30.0)];
    dummyButton.hidden = YES;
    
    // Retain bar buttons
    self.doneItem = doneItem;
    self.filterItem = filterItem;
    self.selectionButton = selectionButton;
//    self.groupItem = groupItem;
    self.checkButton = checkButton;
    self.cancelItem = cancelItem;
    self.clearItem = clearItem;
    self.checkItem = checkItem;
    self.buttonItem = buttonItem;

    // Navigation bar
    [self _setupBarButtonItem];
    
    // Toolbar
    self.navigationController.toolbarHidden = self.imagePickerController.toolBarHidden;
    [self setToolbarItems:@[filterItem, flexibleSpaceItem, buttonItem, flexibleSpaceItem, clearItem] animated:NO];
    

    // Title
    BOOL canSelectGroups = YES;
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(canSelectGroups)]) {
        canSelectGroups = [self.imagePickerController.imagePickerControllerDelegate canSelectGroups];
    }

    if (canSelectGroups) {
        UIButton* titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [titleButton addTarget:self action:@selector(_tappedGroup:) forControlEvents:UIControlEventTouchUpInside];
    //    [titleButton setTitleColor:tintColor forState:UIControlStateNormal];
        CGRect frame = self.navigationController.navigationBar.frame;
        titleButton.frame = frame;
        self.navigationItem.titleView = titleButton;
        self.titleButton = titleButton;
    }
    
    // Collection view
    self.collectionView.allowsMultipleSelection = YES;
    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerSelectCell.class);
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:LKImagePickerControllerBundleManager.bundle]
          forCellWithReuseIdentifier:cellIdentifier];
    
    NSString* headerIdentifier = NSStringFromClass(LKImagePickerControllerSelectHeaderView.class);
    [self.collectionView registerNib:[UINib nibWithNibName:headerIdentifier bundle:LKImagePickerControllerBundleManager.bundle]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerIdentifier];
    
    UIEdgeInsets collectionViewInsets = self.imagePickerController.selectionViewContentInset;
    self.collectionView.contentInset = collectionViewInsets;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(collectionViewInsets.top, 0, collectionViewInsets.bottom, 0);
    
    // Update controls
    [self.assetsManager reloadAssetsGroup];
    [self _updateControls];

    // Empty view
    LKImagePickerControllerEmptyView* emptyView = LKImagePickerControllerEmptyView.emptyView;
    emptyView.hidden = YES;
    [self.view addSubview:emptyView];
    self.emptyView = emptyView;
    
    
    // handle deleagte
    if ([self.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(completionButtonTitle)])
    {
        [self.doneItem setTitle:[self.imagePickerController.imagePickerControllerDelegate completionButtonTitle]];
    }
    
    // Wait Indicator
    UIImageView* waitIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 44, 44)];

    //waitIndicatorView.image = [UIImage imageNamed:@"WaitIndicator1.png" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    UIImage* image00 = [UIImage imageNamed:@"LKImagePickerController_WaitIndicator00.png" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    UIImage* image11 = [UIImage imageNamed:@"LKImagePickerController_WaitIndicator11.png" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    UIImage* image12 = [UIImage imageNamed:@"LKImagePickerController_WaitIndicator12.png" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    UIImage* image21 = [UIImage imageNamed:@"LKImagePickerController_WaitIndicator21.png" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
    UIImage* image22 = [UIImage imageNamed:@"LKImagePickerController_WaitIndicator22.png" inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];

    waitIndicatorView.animationImages = @[
                                          image11,
                                          image12,
                                          image00,
                                          image21,
                                          image22,
                                          image21,
                                          image00,
                                          image12
                                               ];
    waitIndicatorView.animationDuration = 1.0;
    waitIndicatorView.animationRepeatCount = 10000;
    
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGRect frame = waitIndicatorView.frame;
    frame.origin.x = (screenSize.width - frame.size.width) / 2.0;
    frame.origin.y = (screenSize.height - frame.size.height) / 2.0;
    waitIndicatorView.frame = frame;

    UIView* view = UIApplication.sharedApplication.keyWindow;
    [view addSubview:waitIndicatorView];
    self.waitIndicatorView = waitIndicatorView;
    
    
    // Gestures
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPress:)];
    lpgr.delegate = self;
    lpgr.minimumPressDuration = 0.25;
    //lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.firstReloadingFinished) {
        [self.waitIndicatorView startAnimating];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbar.hidden = NO;
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self _updateControls];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbar.hidden = YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSArray* indexPaths = [[self.collectionView indexPathsForVisibleItems] sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath* i1, NSIndexPath* i2) {
        return [i1 compare:i2];
    }];
    if (indexPaths.count) {
        NSInteger index = indexPaths.count / 2;
        self.currentIndexPath = indexPaths[index];
    } else {
        self.currentIndexPath = nil;
    }
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.collectionView.alpha = 0.0;
                     }];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView performBatchUpdates:nil completion:nil];
    
    if (self.currentIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:NO];
        self.currentIndexPath = nil;
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.collectionView.alpha = 1.0;
                     }];
}

#pragma mark - API
- (void)deselectAll
{
    [self.assetsManager removeAllSelectedAssets];
    [self _updateControls];
    [self.collectionView reloadData];
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerAssetsManagerDidAllDeselectNotification
                                                      object:self];
}

- (void)displayMainScreenAnimated:(BOOL)animated
{
    [self _setDisplayingSelectedOnly:NO animated:animated];
}

- (void)scrollToIndexPath:(NSIndexPath*)indexPath
{
    int maxSections = [self.collectionView numberOfSections];
    if (maxSections <= indexPath.section) {
        return;
    }
    int maxItems = [self.collectionView numberOfItemsInSection:indexPath.section];
    if (maxItems <= indexPath.item) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}


#pragma mark - Properties
- (void)_setDisplayingSelectedOnly:(BOOL)displayingSelectedOnly animated:(BOOL)animated
{
    if (_displayingSelectedOnly == displayingSelectedOnly) {
        return;
    }
    _displayingSelectedOnly = displayingSelectedOnly;
    
    if (_displayingSelectedOnly) {
        self.displayingAssetsCollection = [self _assetsCollectionWithAssetsGroup:nil orAssets:self.assetsManager.sortedArrayOfSelectedAssets];
        self.displayingAssetsCollection.filter = [LKAssetsCollectionGenericFilter filterWithType:LKAssetsCollectionGenericFilterTypeAll];
    } else {
        self.displayingAssetsCollection = self.assetsCollection;
    }
    [self _reloadAndSetupSelections];
    
    if (animated) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionReveal];
        [animation setSubtype:_displayingSelectedOnly ? kCATransitionFromTop: kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:0.5];
        [self.collectionView.layer addAnimation:animation forKey:@"CATransitionReloadAnimation"];
    }

    if (_displayingSelectedOnly) {
        //        self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"SelectionScreen.Title"];
        [self.titleButton setTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"SelectionScreen.Title"]
                          forState:UIControlStateNormal];
        self.titleButton.enabled = NO;
        self.navigationItem.rightBarButtonItem = self.checkItem;
        self.navigationItem.leftBarButtonItem = self.emptyItem;
        self.checkButton.hidden = NO;
        self.filterItem.title = LK_IMAGE_PICKER_CONTROLLER_SPACHE;
        self.filterItem.enabled = NO;
    } else {
        //        self.title = self.assetsManager.assetsGroup.name;
        [self.titleButton setTitle:self._titleString forState:UIControlStateNormal];
        self.titleButton.enabled = YES;
        [self _setupBarButtonItem];
        self.checkButton.hidden = YES;
        self.filterItem.enabled = YES;
    }
    
    [self _clearAlert];
    [self _updateControls];
}

- (void)setDisplayingSelectedOnly:(BOOL)displayingSelectedOnly
{
    [self _setDisplayingSelectedOnly:displayingSelectedOnly animated:YES];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.displayingAssetsCollection.entries.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LKAssetsCollectionEntry* entry = self.displayingAssetsCollection.entries[section];
    return entry.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKImagePickerControllerSelectCell.class)
                                                                            forIndexPath:indexPath];
    LKAsset* asset = [self.displayingAssetsCollection assetForIndexPath:indexPath];
    cell.alternativeIconImage = self.imagePickerController.alternativeIconImage; // must be first before setting asset
    cell.asset = asset;
    cell.checked = [self.assetsManager containsSelectedAsset:asset];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LKImagePickerControllerSelectHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(LKImagePickerControllerSelectHeaderView.class) forIndexPath:indexPath];
        view.collectionEntry = self.displayingAssetsCollection.entries[indexPath.section];
        view.allSelected = [self _allSelectedInSection:indexPath.section];
        view.section = indexPath.section;
        reusableView = view;
    }
    return reusableView;
}


#pragma mark - UICollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    LKAssetsCollectionEntry* collectionEntry = self.displayingAssetsCollection.entries[section];
    if (collectionEntry.assets.count > 0) {
        return ((UICollectionViewFlowLayout*)collectionViewLayout).headerReferenceSize;
    } else {
        return CGSizeZero;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self _openDetailViewAtIndexPath:indexPath];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat viewWidth = fmin(size.width, size.height);
    CGFloat cellWidth;
    CGFloat div = 4.0;
    
    while (1) {
        cellWidth = viewWidth / div;
        if (cellWidth <= 100.0) {
            break;
        }
        div += 1.0;
        if (div > 15.0) {
            break;
        }
    }
    return CGSizeMake(cellWidth, cellWidth);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (actionSheet.tag  == LKImagePickerControllerSelectViewSheetResetSelections) {
            [self deselectAll];
        } else if (actionSheet.tag == LKImagePickerControllerSelectViewSheetLoseSelections) {
            [self _openGroupView];
        }
    }
}


#pragma mark - Callback
//- (void)setIndexPathsForSelectedItems:(NSArray*)indexPathsForSelectedItems
//{
//    NSArray* oldSelectedItems = self.collectionView.indexPathsForSelectedItems;
//    for (NSIndexPath* indexPath in indexPathsForSelectedItems) {
//        if (![oldSelectedItems containsObject:indexPath]) {
//            [self _postNotificationName:LKImagePickerControllerAssetsManagerDidSelectNotification
//                              indexPath:indexPath];
//        }
//    }
//    for (NSIndexPath* indexPath in oldSelectedItems) {
//        if (![indexPathsForSelectedItems containsObject:indexPath]) {
//            [self _postNotificationName:LKImagePickerControllerAssetsManagerDidDeselectNotification
//                              indexPath:indexPath];
//        }
//    }
//    [self _updateControls];
//}

- (void)didSelectAssetsGroup:(LKAssetsGroup*)assetsGroup
{
    [self deselectAll];
    [self.assetsManager setAndReloadAssetsGroup:assetsGroup];
}


- (void)didChangeFilterType
{
    self.displayingAssetsCollection.filter = self.assetsManager.filter.assetsFilter;
    [self _reloadAndSetupSelections];
    [self _updateControls];
}


#pragma mark - Actions
- (IBAction)checkmarkTouchded:(id)sender event:(UIEvent*)event
{
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.collectionView];
    NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath == nil) {
        return;
    }

    LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.checked) {
        if (self.assetsManager.reachedMaximumOfSelections) {
            [cell alert];
            [self _alertForFilled];
            cell.checked = NO;
        } else {
            [self.assetsManager selectAsset:[self.displayingAssetsCollection assetForIndexPath:indexPath]];
            [self _updateControls];
            
            [self _postNotificationName:LKImagePickerControllerAssetsManagerDidSelectNotification
                              indexPath:indexPath];
        }
    } else {
        [self.assetsManager deselectAsset:[self.displayingAssetsCollection assetForIndexPath:indexPath]];
        [self _updateControls];
        
        [self _postNotificationName:LKImagePickerControllerAssetsManagerDidDeselectNotification
                          indexPath:indexPath];
    }
    
}


@end

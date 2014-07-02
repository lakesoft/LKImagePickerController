
//
//  LKImagePickerControllerSelectViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
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
#import "LKImagePickerControlelrCheckmarkButton.h"
#import "LKImagePickerControllerCloseButton.h"

NSString * const LKImagePickerControllerSelectViewControllerDidSelectCellNotification = @"LKImagePickerControllerSelectViewControllerDidSelectCellNotification";
NSString * const LKImagePickerControllerSelectViewControllerDidDeselectCellNotification = @"LKImagePickerControllerSelectViewControllerDidDeselectCellNotification";
NSString * const LKImagePickerControllerSelectViewControllerDidAllDeselectCellNotification = @"LKImagePickerControllerSelectViewControllerDidAllDeselectCellNotification";
NSString * const LKImagePickerControllerSelectViewControllerKeyIndexPath = @"LKImagePickerControllerSelectViewControllerKeyIndexPath";
NSString * const LKImagePickerControllerSelectViewControllerKeyAllSelected = @"LKImagePickerControllerSelectViewControllerAllSelected";

NS_ENUM(NSInteger, LKImagePickerControllerSelectViewSheet) {
    LKImagePickerControllerSelectViewSheetResetSelections,
    LKImagePickerControllerSelectViewSheetLoseSelections,
};



@interface LKImagePickerControllerSelectViewController () <UIActionSheetDelegate>

#pragma mark - Views
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark - LKAasetsLibrary
@property (nonatomic, strong) LKAssetsCollection* assetsCollection;
@property (nonatomic, assign) LKAssetsCollectionGenericGroupingType groupingType;

#pragma mark - Controls
@property (nonatomic, weak) LKImagePickerControllerSelectionButton* selectionButton;
@property (nonatomic, weak) LKImagePickerControlelrCheckmarkButton* checkButton;
@property (nonatomic, weak) UIBarButtonItem* doneItem;
@property (nonatomic, weak) UIBarButtonItem* cancelItem;
@property (nonatomic, weak) UIBarButtonItem* filterItem;
@property (nonatomic, strong) UIBarButtonItem* groupItem;
@property (nonatomic, strong) UIBarButtonItem* checkItem;

#pragma mark - Models
@property (nonatomic, strong) NSMutableOrderedSet* selectedAssets;  // <LKAssets>
@property (nonatomic, assign) BOOL displayingSelectedOnly;
@property (nonatomic, strong) LKAssetsCollection* displayingAssetsCollection;

@end

@implementation LKImagePickerControllerSelectViewController

#pragma mark - Privates
- (NSArray*)_sortedArrayByDateWithOrderedSet:(NSOrderedSet*)orderedSet
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:orderedSet.array];
    [array sortUsingComparator:^NSComparisonResult(LKAsset* asset1, LKAsset* asset2) {
        return [asset1.date compare:asset2.date];
    }];
    return array;
}

#pragma mark - Privates (LKAssetsLibrary)
- (void)setDisplayingAssetsCollection:(LKAssetsCollection *)displayingAssetsCollection
{
    _displayingAssetsCollection = displayingAssetsCollection;
    displayingAssetsCollection.filter = [self.assetsManager.filter assetsFilter];
}

- (void)_assetsGroupDidReload:(NSNotification*)notification

{
    self.assetsCollection = [self _assetsCollectionWithAssetsGroup:self.assetsManager.assetsGroup orAssets:nil];
    self.displayingAssetsCollection = self.assetsCollection;
    self.displayingSelectedOnly = NO;
    [self _reloadAndSetupSelections];
    self.title = self.assetsCollection.assetsGroup.name;
    [self _updateControls];
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
    NSDictionary* userInfo = @{LKImagePickerControllerSelectViewControllerKeyIndexPath:indexPath,
                               LKImagePickerControllerSelectViewControllerKeyAllSelected:@(allSelected)};
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
        if (![self.selectedAssets containsObject:asset]) {
            allSelected = NO;
            break;
        }
    }
    return allSelected;
}

- (BOOL)_allSelected
{
    return (self.selectedAssets.count == self.displayingAssetsCollection.numberOfAssets);
}

- (void)_resetSelections
{
    for (NSIndexPath* indexPath in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    [self.selectedAssets removeAllObjects];
    [self _updateControls];
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerSelectViewControllerDidAllDeselectCellNotification
                                                      object:self];
}

- (void)_reloadAndSetupSelections
{
    [self.collectionView reloadData];
    for (LKAsset* asset in self.selectedAssets) {
        NSIndexPath* indexPath = [self.displayingAssetsCollection indexPathForAsset:asset];
        if (indexPath) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
    NSInteger lastSection = self.displayingAssetsCollection.entries.count-1;
    if (lastSection >= 0) {
        LKAssetsCollectionEntry* lastEntry = self.displayingAssetsCollection.entries[lastSection];
        NSInteger lastItem = lastEntry.assets.count - 1;
        if (lastItem >=0 ) {
            NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:lastItem
                                                             inSection:lastSection];
            [self.collectionView scrollToItemAtIndexPath:lastIndexPath
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:NO];
        }
    }

}

#pragma mark - Privates (Actions)
//- (void)_tappedClear:(id)sender
//{
//    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Selection.DeselectAll"]
//                                                       delegate:self
//                                              cancelButtonTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.Cancel"]
//                                         destructiveButtonTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.OK"]                                              otherButtonTitles:nil];
//    sheet.tag = LKImagePickerControllerSelectViewSheetResetSelections;
//    [sheet showFromToolbar:self.navigationController.toolbar];
//}

- (void)_selectAllItems
{
    for (NSInteger section=0; section < self.displayingAssetsCollection.entries.count; section++) {
        LKAssetsCollectionEntry* entry = self.displayingAssetsCollection.entries[section];
        for (NSInteger item=0; item < entry.assets.count; item++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            LKAsset* asset = entry.assets[item];
            [self.selectedAssets addObject:asset];
            [self _postNotificationName:LKImagePickerControllerSelectViewControllerDidSelectCellNotification
                              indexPath:indexPath];
        }
    }
    [self _updateControls];
}

- (void)_tappedCheckbutton:(id)sender
{
    if (self.selectedAssets.count > 0) {
        [self _resetSelections];
    } else {
        [self _selectAllItems];
    }
}

- (void)_tappedSelectionNumber:(id)sender
{
    self.displayingSelectedOnly = !self.displayingSelectedOnly;

    if (self.displayingSelectedOnly) {
        NSArray* assets = [self _sortedArrayByDateWithOrderedSet:self.selectedAssets];
        self.displayingAssetsCollection = [self _assetsCollectionWithAssetsGroup:nil orAssets:assets];
    } else {
        self.displayingAssetsCollection = self.assetsCollection;
    }
    [self _reloadAndSetupSelections];

    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:self.displayingSelectedOnly ? kCATransitionFromTop: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setFillMode:kCAFillModeBoth];
    [animation setDuration:0.75];
    [self.collectionView.layer addAnimation:animation forKey:@"CATransitionReloadAnimation"];
    
    if (self.displayingSelectedOnly) {
        self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"SelectionScreen.Title"];
        self.navigationItem.rightBarButtonItem = self.checkItem;
        self.checkButton.hidden = NO;
    } else {
        self.title = self.assetsManager.assetsGroup.name;
        self.navigationItem.rightBarButtonItem = self.groupItem;
        self.checkButton.hidden = YES;
    }
    
    [self _updateControls];
}

- (void)_selectedGrouping:(UISegmentedControl*)sender
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, sender);
}

- (void)_tappedDone:(id)sender
{
    NSLog(@"%@", self.selectedAssets);
}

- (IBAction)tappedHeader:(UIButton*)sender
{
    LKImagePickerControllerSelectHeaderView* headerView = (LKImagePickerControllerSelectHeaderView*)sender.superview;
    NSInteger section = headerView.section;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    
    BOOL allSelected = [self _allSelectedInSection:section];

    for (NSInteger item=0; item < numberOfItems; item++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        if (allSelected) {
            [self.collectionView deselectItemAtIndexPath:indexPath
                                                animated:NO];
            [self.selectedAssets removeObject:[self.displayingAssetsCollection assetForIndexPath:indexPath]];
        } else {
            [self.collectionView selectItemAtIndexPath:indexPath
                                              animated:NO
                                        scrollPosition:UICollectionViewScrollPositionNone];
            [self.selectedAssets addObject:[self.displayingAssetsCollection assetForIndexPath:indexPath]];
        }
    }
    headerView.allSelected = !allSelected;
    [self _updateControls];
}

- (void)_tappedCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_tappedOrganize:(id)sender
{
    if (self.collectionView.indexPathsForSelectedItems.count > 0) {
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

#pragma mark - Privates (Presentations)
- (void)_updateControls
{
    self.selectionButton.numberOfSelections = self.selectedAssets.count;
    self.selectionButton.active = self.displayingSelectedOnly;
    self.doneItem.enabled = self.selectedAssets.count > 0;
    self.filterItem.title = self.assetsManager.filter.description;
    self.checkButton.active = self.selectedAssets.count > 0 && self._allSelected;
}

#pragma mark - Privates (Navigations)
- (void)_openGroupView
{
    LKImagePickerControllerGroupTableViewController* viewController = LKImagePickerControllerGroupTableViewController.new;
    viewController.assetsManager = self.assetsManager;
    viewController.selectViewController = self;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)_openFilterView
{
    LKImagePickerControllerFilterSelectionViewController* viewController = LKImagePickerControllerFilterSelectionViewController.new;
    viewController.assetsManager = self.assetsManager;
    viewController.selectViewController = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)_openDetailViewAtIndexPath:(NSIndexPath*)indexPath
{
    LKImagePickerControllerDetailViewController* viewController = LKImagePickerControllerDetailViewController.new;
    viewController.assetsCollection = self.displayingAssetsCollection;
    viewController.indexPath = indexPath;
    viewController.selectedAssets = self.selectedAssets;
    viewController.indexPathsForSelectedItems = self.collectionView.indexPathsForSelectedItems;
    viewController.selectViewController = self;
    [self.navigationController pushViewController:viewController animated:YES];
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
//        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        [self _openDetailViewAtIndexPath:indexPath];
    }
}


#pragma mark - Basics

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:LKImagePickerControllerBundleManager.bundle];
    if (self) {
        self.selectedAssets = [NSMutableOrderedSet orderedSet];
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
    // Bar buttons
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[LKImagePickerControllerBundleManager localizedStringForKey:@"Common.Back"] style:UIBarButtonItemStylePlain target:nil action:nil];

    LKImagePickerControllerCloseButton* closeButton = [LKImagePickerControllerCloseButton closeButtonWithTarget:self action:@selector(_tappedCancel:)];
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIBarButtonItem* groupItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(_tappedOrganize:)];

    UIBarButtonItem* filterItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(_tappedFilter:)];

    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_tappedDone:)];

    LKImagePickerControllerSelectionButton* selectionButton =
    [LKImagePickerControllerSelectionButton selectionButtonTarget:self action:@selector(_tappedSelectionNumber:)];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:selectionButton];

    LKImagePickerControlelrCheckmarkButton* checkButton = [LKImagePickerControlelrCheckmarkButton checkmarkButtonWithTarget:self action:@selector(_tappedCheckbutton:)];
    checkButton.hidden = YES;
    UIBarButtonItem* checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    
    LKImagePickerControlelrCheckmarkButton* dummyButton = [LKImagePickerControlelrCheckmarkButton checkmarkButtonWithTarget:nil action:nil];
    dummyButton.hidden = YES;
    
    // Navigation bar
    self.navigationItem.leftBarButtonItem = filterItem;
    self.navigationItem.rightBarButtonItem = groupItem;

    // Toolbar
    self.navigationController.toolbarHidden = NO;
                  [self setToolbarItems:@[cancelItem, flexibleSpaceItem, buttonItem, flexibleSpaceItem, doneItem] animated:NO];
    
    // Retain bar buttons
    self.doneItem = doneItem;
    self.filterItem = filterItem;
    self.selectionButton = selectionButton;
    self.groupItem = groupItem;
    self.checkButton = checkButton;
    self.cancelItem = cancelItem;
    self.checkItem = checkItem;
    
    // Collection view
    self.collectionView.allowsMultipleSelection = YES;
    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerSelectCell.class);
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:LKImagePickerControllerBundleManager.bundle]
          forCellWithReuseIdentifier:cellIdentifier];
    
    NSString* headerIdentifier = NSStringFromClass(LKImagePickerControllerSelectHeaderView.class);
    [self.collectionView registerNib:[UINib nibWithNibName:headerIdentifier bundle:LKImagePickerControllerBundleManager.bundle]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerIdentifier];

    // Gestures
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(_handleLongPress:)];
    lpgr.minimumPressDuration = 0.2;
    [self.collectionView addGestureRecognizer:lpgr];

    // Update controls
    [self.assetsManager reloadAssetsGroup];
    [self _updateControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbar.hidden = YES;
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
    cell.asset = [self.displayingAssetsCollection assetForIndexPath:indexPath];
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
//- (BOOL)_collectionView:(UICollectionView*)collectionView shouldSelectDeSelectItemAtIndexPath:(NSIndexPath*)indexPath
//{
//    LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[collectionView cellForItemAtIndexPath:indexPath];
//    
//    if (cell.touchedOnCheckmark) {
//        return YES;
//    } else {
//        LKImagePickerControllerDetailViewController* viewController = LKImagePickerControllerDetailViewController.new;
//        viewController.assetsCollection = self.displayingAssetsCollection;
//        viewController.indexPath = indexPath;
//        viewController.selectedAssets = self.selectedAssets;
//        viewController.indexPathsForSelectedItems = self.collectionView.indexPathsForSelectedItems;
//        viewController.selectViewController = self;
//        [self.navigationController pushViewController:viewController animated:YES];
//        return NO;
//    }
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self _collectionView:collectionView shouldSelectDeSelectItemAtIndexPath:indexPath];
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self _collectionView:collectionView shouldSelectDeSelectItemAtIndexPath:indexPath];
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets addObject:[self.displayingAssetsCollection assetForIndexPath:indexPath]];
    [self _updateControls];

    [self _postNotificationName:LKImagePickerControllerSelectViewControllerDidSelectCellNotification
                      indexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets removeObject:[self.displayingAssetsCollection assetForIndexPath:indexPath]];
    [self _updateControls];
    
    [self _postNotificationName:LKImagePickerControllerSelectViewControllerDidDeselectCellNotification
                      indexPath:indexPath];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (actionSheet.tag  == LKImagePickerControllerSelectViewSheetResetSelections) {
            [self _resetSelections];
        } else if (actionSheet.tag == LKImagePickerControllerSelectViewSheetLoseSelections) {
            [self _openGroupView];
        }
    }
}


#pragma mark - Callback
- (void)setIndexPathsForSelectedItems:(NSArray*)indexPathsForSelectedItems
{
    NSArray* oldSelectedItems = self.collectionView.indexPathsForSelectedItems;
    for (NSIndexPath* indexPath in indexPathsForSelectedItems) {
        if (![oldSelectedItems containsObject:indexPath]) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self _postNotificationName:LKImagePickerControllerSelectViewControllerDidSelectCellNotification
                              indexPath:indexPath];
        }
    }
    for (NSIndexPath* indexPath in oldSelectedItems) {
        if (![indexPathsForSelectedItems containsObject:indexPath]) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            [self _postNotificationName:LKImagePickerControllerSelectViewControllerDidDeselectCellNotification
                              indexPath:indexPath];
        }
    }
    [self _updateControls];
}

- (void)didSelectAssetsGroup:(LKAssetsGroup*)assetsGroup
{
    [self _resetSelections];
    [self.assetsManager setAndReloadAssetsGroup:assetsGroup];
}


- (void)didChangeFilterType
{
    [self _updateControls];
    self.displayingAssetsCollection.filter = [self.assetsManager.filter assetsFilter];
    [self _reloadAndSetupSelections];
}

@end

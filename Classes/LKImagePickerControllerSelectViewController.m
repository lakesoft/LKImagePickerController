
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
@property (nonatomic, strong) LKAssetsCollectionGenericFilter* filter;
@property (nonatomic, strong) LKAssetsCollectionGenericSorter* sorter;
@property (nonatomic, assign) LKAssetsCollectionGenericGroupingType groupingType;

#pragma mark - Controls
@property (nonatomic, weak) LKImagePickerControllerSelectionButton* selectionButton;
@property (nonatomic, weak) UIBarButtonItem* doneItem;
@property (nonatomic, weak) UIBarButtonItem* filterItem;

#pragma mark - Models
@property (nonatomic, strong) NSMutableOrderedSet* selectedAssets;

@end

@implementation LKImagePickerControllerSelectViewController

#pragma mark - Privates (LKAssetsLibrary)
- (void)_assetsGroupDidReload:(NSNotification*)notification
{
    [self _setupAssetsCollection];
    [self.collectionView reloadData];
    NSInteger lastSection = self.assetsCollection.entries.count-1;
    if (lastSection >= 0) {
        LKAssetsCollectionEntry* lastEntry = self.assetsCollection.entries[lastSection];
        NSInteger lastItem = lastEntry.assets.count - 1;
        if (lastItem >=0 ) {
            NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:lastItem
                                                             inSection:lastSection];
            [self.collectionView scrollToItemAtIndexPath:lastIndexPath
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:NO];
        }
    }
    self.title = self.assetsCollection.group.name;

//    [NSNotificationCenter.defaultCenter postNotificationName:FilterViewControllerDidChangeAssetsCollectionNotification
//                                                      object:self.assetsCollection];
}

- (void)_setupAssetsCollection
{
    if (self.groupingType == 0) {
        self.groupingType = LKAssetsCollectionGenericGroupingTypeDaily;
    }
    
    LKAssetsCollectionGenericGrouping* grouping = [LKAssetsCollectionGenericGrouping groupingWithType:self.groupingType];
    
    self.assetsCollection = [LKAssetsCollection assetsCollectionWithGroup:self.assetsManager.assetsGroup grouping:grouping];
    self.assetsCollection.filter = self.filter;
    self.assetsCollection.sorter = self.sorter;
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
    BOOL allSelected = YES;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    for (NSInteger item=0; item < numberOfItems; item++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        LKAsset* asset = [self.assetsCollection assetForIndexPath:indexPath];
        if (![self.selectedAssets containsObject:asset]) {
            allSelected = NO;
            break;
        }
    }
    return allSelected;
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


#pragma mark - Privates (Toolbar Actions)
- (void)_tappedClear:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Clear", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    sheet.tag = LKImagePickerControllerSelectViewSheetResetSelections;
    [sheet showFromToolbar:self.navigationController.toolbar];
}
- (void)_selectedGrouping:(UISegmentedControl*)sender
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, sender);
}

- (void)_tappedDone:(id)sender
{
    NSLog(@"%@", self.selectedAssets);
}

#pragma mark - Privates (Header)
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
            [self.selectedAssets removeObject:[self.assetsCollection assetForIndexPath:indexPath]];
        } else {
            [self.collectionView selectItemAtIndexPath:indexPath
                                              animated:NO
                                        scrollPosition:UICollectionViewScrollPositionNone];
            [self.selectedAssets addObject:[self.assetsCollection assetForIndexPath:indexPath]];
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
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"消えてしまいます", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                             destructiveButtonTitle:NSLocalizedString(@"OK", nil)
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
    self.doneItem.enabled = self.selectedAssets.count > 0;
    self.filterItem.title = self.assetsManager.filter.description;
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
    viewController.assetsCollection = self.assetsCollection;
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
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_tappedCancel:)];
    
    UIBarButtonItem* organizeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(_tappedOrganize:)];

    UIBarButtonItem* filterItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(_tappedFilter:)];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_tappedDone:)];

    LKImagePickerControllerSelectionButton* selectionButton =
    [LKImagePickerControllerSelectionButton selectionButtonTarget:self action:@selector(_tappedClear:)];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:selectionButton];

    // Navigation bar
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = organizeItem;

    // Toolbar
    self.navigationController.toolbarHidden = NO;
                  [self setToolbarItems:@[filterItem, spaceItem, buttonItem, spaceItem, doneItem] animated:NO];
    
    // Retain bar buttons
    self.doneItem = doneItem;
    self.filterItem = filterItem;
    self.selectionButton = selectionButton;

    
    // Collection view
    self.collectionView.allowsMultipleSelection = YES;
    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerSelectCell.class);
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil]
          forCellWithReuseIdentifier:cellIdentifier];
    
    NSString* headerIdentifier = NSStringFromClass(LKImagePickerControllerSelectHeaderView.class);
    [self.collectionView registerNib:[UINib nibWithNibName:headerIdentifier bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerIdentifier];

    // Gestures
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(_handleLongPress:)];
    lpgr.minimumPressDuration = 0.25;
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


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.assetsCollection.entries.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LKAssetsCollectionEntry* entry = self.assetsCollection.entries[section];
    return entry.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKImagePickerControllerSelectCell.class)
                                                                            forIndexPath:indexPath];
    cell.asset = [self.assetsCollection assetForIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LKImagePickerControllerSelectHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(LKImagePickerControllerSelectHeaderView.class) forIndexPath:indexPath];
        view.allSelected = [self _allSelectedInSection:indexPath.section];
        view.collectionEntry = self.assetsCollection.entries[indexPath.section];
        view.section = indexPath.section;
        reusableView = view;
    }
    return reusableView;
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
//        viewController.assetsCollection = self.assetsCollection;
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
    [self.selectedAssets addObject:[self.assetsCollection assetForIndexPath:indexPath]];
    [self _updateControls];

    [self _postNotificationName:LKImagePickerControllerSelectViewControllerDidSelectCellNotification
                      indexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets removeObject:[self.assetsCollection assetForIndexPath:indexPath]];
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


@end

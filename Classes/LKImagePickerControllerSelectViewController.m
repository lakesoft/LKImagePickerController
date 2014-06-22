
//
//  LKImagePickerControllerSelectViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
#import "LKAssetsLibrary.h"
#import "LKImagePickerControllerSelectViewController.h"
#import "LKImagePickerControllerSelectCell.h"
#import "LKImagePickerControllerSelectHeaderView.h"
#import "LKImagePickerControllerAppearance.h"
#import "LKImagePickerControllerDetailViewController.h"
#import "LKImagePickerControllerGroupTableViewController.h"

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
@property (nonatomic, weak) UIButton* selectionButton;
@property (nonatomic, weak) UIBarButtonItem* doneItem;

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
    
    self.assetsCollection = [LKAssetsCollection assetsCollectionWithGroup:self.assetsGroup grouping:grouping];
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


#pragma mark - Privates (Presentations)
- (void)_updateControls
{
    [self.selectionButton setTitle:[NSString stringWithFormat:@"%lu", self.selectedAssets.count]
                          forState:UIControlStateNormal];
    if (self.selectedAssets.count > 0) {
        self.selectionButton.enabled = YES;
        self.selectionButton.backgroundColor = LKImagePickerControllerAppearance.sharedAppearance.checkmarkBackgroundColor;
    } else {
        self.selectionButton.enabled = NO;
        self.selectionButton.backgroundColor = UIColor.clearColor;
    }
    self.doneItem.enabled = self.selectedAssets.count > 0;
}

#pragma mark - Privates (Navigations)
- (void)_openGroupView
{
    LKImagePickerControllerGroupTableViewController* viewController = LKImagePickerControllerGroupTableViewController.new;
    viewController.assetsLibrary = self.assetsLibrary;
    viewController.assetsGroup = self.assetsGroup;
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
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_tappedCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(_tappedOrganize:)];
    
    // Toolbar
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_tappedDone:)];
    
    UIButton* selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43.7, 27)];
    [selectionButton addTarget:self action:@selector(_tappedClear:) forControlEvents:UIControlEventTouchUpInside];
    [selectionButton setTitleColor:UIColor.lightGrayColor
                          forState:UIControlStateDisabled];
    [selectionButton setTitleColor:UIColor.whiteColor
                          forState:UIControlStateNormal];

    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:selectionButton];

    [self setToolbarItems:@[spaceItem, buttonItem, spaceItem, doneItem] animated:NO];

    self.doneItem = doneItem;
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsGroupDidReload:)
                                                 name:LKAssetsGroupDidReloadNotification
                                               object:nil];
    // Gestures
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(_handleLongPress:)];
    lpgr.minimumPressDuration = 0.3;
    [self.collectionView addGestureRecognizer:lpgr];

    // Update controls
    [self.assetsGroup reloadAssets];
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
    self.assetsGroup = assetsGroup;
    [self.assetsGroup reloadAssets];
}


@end

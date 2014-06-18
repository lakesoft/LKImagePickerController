
//
//  LKImagePickerControllerStandardSelectViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/15.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
#import "LKAssetsLibrary.h"
#import "LKImagePickerControllerStandardSelectViewController.h"
#import "LKImagePickerControllerStandardSelectCell.h"
#import "LKImagePickerControllerStandardSelectHeaderView.h"

@interface LKImagePickerControllerStandardSelectViewController ()

#pragma mark - Views
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark - LKAasetsLibrary
@property (nonatomic, strong) LKAssetsCollection* assetsCollection;
@property (nonatomic, strong) LKAssetsCollectionGenericFilter* filter;
@property (nonatomic, strong) LKAssetsCollectionGenericSorter* sorter;
@property (nonatomic, assign) LKAssetsCollectionGenericGroupingType groupingType;

#pragma mark - Controls
@property (nonatomic, weak) UISegmentedControl* groupingSegment;
@property (nonatomic, weak) UILabel* selectionLabel;

#pragma mark - Models
@property (nonatomic, strong) NSMutableSet* selectedAssets;

@end

@implementation LKImagePickerControllerStandardSelectViewController

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

#pragma mark - Privates (Toolbar Actions)
- (void)_tappedClear:(id)sender
{
    for (NSIndexPath* indexPath in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    [self.selectedAssets removeAllObjects];
    [self _updateSelectionLabel];
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
    LKImagePickerControllerStandardSelectHeaderView* headerView = (LKImagePickerControllerStandardSelectHeaderView*)sender.superview;
    NSInteger section = headerView.section;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    
    BOOL allSelected = YES;
    for (NSInteger item=0; item < numberOfItems; item++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell && !cell.isSelected) {
            allSelected = NO;
            break;
        }
    }

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
    [self _updateSelectionLabel];
}

#pragma mark - Privates (Presentations)
- (void)_updateControls
{
    [self _updateGroupSegment];
    [self _updateSelectionLabel];
}
- (void)_updateGroupSegment
{
    self.groupingSegment.selectedSegmentIndex = (self.groupingType == LKAssetsCollectionGenericGroupingTypeDaily ? 0 : 1);
}
- (void)_updateSelectionLabel
{
    self.selectionLabel.text = [NSString stringWithFormat:@"%lu", self.selectedAssets.count];
}

#pragma mark - Basics

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedAssets = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigtion
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(_tappedClear:)];
    
    // Toolbar
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_tappedDone:)];
    
    UISegmentedControl* groupingSegment = [[UISegmentedControl alloc] initWithItems:@[@"daily", @"hourly"]];
    [groupingSegment addTarget:self action:@selector(_selectedGrouping:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem* groupingItem = [[UIBarButtonItem alloc] initWithCustomView:groupingSegment];
    
    UILabel* selectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 27)];
    selectionLabel.textAlignment = NSTextAlignmentCenter;
    selectionLabel.textColor = UIColor.grayColor;
//    CALayer* layer = selectionLabel.layer;
//    layer.cornerRadius = 13.0;
//    layer.masksToBounds = YES;
//    layer.borderWidth = 0.5;
//    layer.borderColor = self.selectionLabel.textColor.CGColor;
    selectionLabel.adjustsFontSizeToFitWidth = YES;
    UIBarButtonItem* labelItem = [[UIBarButtonItem alloc] initWithCustomView:selectionLabel];
    self.selectionLabel = selectionLabel;
    
    [self setToolbarItems:@[labelItem, spaceItem, groupingItem, spaceItem, doneItem] animated:NO];

    
    // Collection view
    self.collectionView.allowsMultipleSelection = YES;
    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerStandardSelectCell.class);
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil]
          forCellWithReuseIdentifier:cellIdentifier];
    
    NSString* headerIdentifier = NSStringFromClass(LKImagePickerControllerStandardSelectHeaderView.class);
    [self.collectionView registerNib:[UINib nibWithNibName:headerIdentifier bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_assetsGroupDidReload:)
                                                 name:LKAssetsGroupDidReloadNotification
                                               object:nil];
    [self.assetsGroup reloadAssets];
    [self _updateControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    LKImagePickerControllerStandardSelectCell* cell = (LKImagePickerControllerStandardSelectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKImagePickerControllerStandardSelectCell.class)
                                                                            forIndexPath:indexPath];
    cell.asset = [self.assetsCollection assetForIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LKImagePickerControllerStandardSelectHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(LKImagePickerControllerStandardSelectHeaderView.class) forIndexPath:indexPath];
        view.collectionEntry = self.assetsCollection.entries[indexPath.section];
        view.section = indexPath.section;
        reusableView = view;
    }
    return reusableView;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets addObject:[self.assetsCollection assetForIndexPath:indexPath]];
    [self _updateSelectionLabel];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets removeObject:[self.assetsCollection assetForIndexPath:indexPath]];
    [self _updateSelectionLabel];
}
@end

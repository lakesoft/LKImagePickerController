//
//  LKImagePickerControllerDetailViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/06/19.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKImagePickerControllerDetailViewController.h"
#import "LKImagePickerControllerDetailCell.h"
#import "LKImagePickerControllerSelectCell.h"
#import "LKImagePickerControllerSelectionButton.h"

#define LKImagePickerControlDetailThumbnailSize (CGSizeMake(50.0,50.0))

@interface LKImagePickerControllerDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;
@property (assign, nonatomic) CGPoint contentOffset;
@property (assign, nonatomic) BOOL scrollDirectionLeft;
@property (assign, nonatomic) BOOL scrollingByThumbnailView;

@end

@implementation LKImagePickerControllerDetailViewController

#pragma mark - Privates
- (void)_updateControls
{
    NSLog(@"updated");
}
- (void)_tappedClear:(id)sender
{
    NSLog(@"clear");
}

- (void)_assetsGroupDidReload:(NSNotification*)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Privtates (Gestures)
-(void)_handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.thumbnailCollectionView];
    
    NSIndexPath *indexPath = [self.thumbnailCollectionView indexPathForItemAtPoint:p];
    if (indexPath){
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
        self.scrollingByThumbnailView = YES;
    }
}


#pragma mark - Basics
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
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
    self.title = NSLocalizedString(@"Photos", nil);
    
    // Notifications
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_assetsGroupDidReload:)
                                               name:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification
                                             object:nil];

    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerDetailCell.class);
    
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil]
          forCellWithReuseIdentifier:cellIdentifier];
    NSString* cellIdentifier2 = NSStringFromClass(LKImagePickerControllerSelectCell.class);
    [self.thumbnailCollectionView registerNib:[UINib nibWithNibName:cellIdentifier2 bundle:nil]
                   forCellWithReuseIdentifier:cellIdentifier2];
    
    self.collectionView.allowsMultipleSelection = YES;
    self.thumbnailCollectionView.allowsMultipleSelection = YES;

//    [self.collectionView reloadData];
//    [self.thumbnailCollectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:self.indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    [self.thumbnailCollectionView scrollToItemAtIndexPath:self.indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    
    for (NSIndexPath* indexPath in self.indexPathsForSelectedItems) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.thumbnailCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    // Gestures
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(_handleLongPress:)];
    lpgr.minimumPressDuration = 0.2;
    [self.thumbnailCollectionView addGestureRecognizer:lpgr];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbar.hidden = YES;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.selectViewController setIndexPathsForSelectedItems:self.collectionView.indexPathsForSelectedItems];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (NSInteger)_indexForIndexPath:(NSIndexPath*)indexPath
{
    NSInteger index = 0;
    for (NSInteger section=0; section < indexPath.section; section++) {
        LKAssetsCollectionEntry* entry = self.assetsCollection.entries[section];
        index += entry.assets.count;
    }
    index += indexPath.item;
    
    return index;
}

- (NSIndexPath*)_indexPathFromIndex:(NSInteger)index
{
    NSInteger section = 0;
    NSInteger item = 0;
    NSInteger count = index;
    while (count) {
        NSInteger numberOfEntries = self.assetsCollection.entries.count;
        if (numberOfEntries <= section) {
            return nil;
        }
        LKAssetsCollectionEntry* entry = self.assetsCollection.entries[section];
        NSInteger numberOfAssets = entry.assets.count;
        if (count < numberOfAssets) {
            item = count;
            break;
        }
        count -= numberOfAssets;
        section++;
    }
    return [NSIndexPath indexPathForItem:item inSection:section];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        CGSize size = self.collectionView.frame.size;
        return size;
    } else {
        return LKImagePickerControlDetailThumbnailSize;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.collectionView) {
        return;
    }

    CGFloat dx = self.contentOffset.x - self.collectionView.contentOffset.x;
    self.scrollDirectionLeft = dx > 0;
    CGSize size = self.collectionView.frame.size;
    CGSize cellSize = LKImagePickerControlDetailThumbnailSize;
    
    self.contentOffset = self.collectionView.contentOffset;
    
    if (!self.scrollingByThumbnailView) {
        CGFloat dr = dx / self.collectionView.frame.size.width;
        CGPoint thumbnailContentOffset = self.thumbnailCollectionView.contentOffset;
        thumbnailContentOffset.x = thumbnailContentOffset.x - cellSize.width*dr;
        self.thumbnailCollectionView.contentOffset = thumbnailContentOffset;
    }

    if (fmod(self.collectionView.contentOffset.x, size.width) == 0) {
        if (self.scrollingByThumbnailView) {
            self.scrollingByThumbnailView = NO;
        } else {
            CGPoint p = self.contentOffset;
            p.x += size.width / 2.0;
            p.y += size.height / 2.0;
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:p];
            if (indexPath) {
                self.indexPath = indexPath;
                [self.thumbnailCollectionView scrollToItemAtIndexPath:self.indexPath
                                                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                             animated:YES];
            }
        }
    }
}


#pragma mark - UICollectionViewDatasource
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
    if (collectionView == self.collectionView) {
        LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKImagePickerControllerDetailCell.class)
                                                                                forIndexPath:indexPath];
        cell.asset = [self.assetsCollection assetForIndexPath:indexPath];
        return cell;
    } else {
        LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKImagePickerControllerSelectCell.class)
                                                                                                                                forIndexPath:indexPath];
        cell.asset = [self.assetsCollection assetForIndexPath:indexPath];
        return cell;
    }
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets addObject:[self.assetsCollection assetForIndexPath:indexPath]];
    if (collectionView == self.collectionView) {
        [self.thumbnailCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    } else {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    [self _updateControls];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets removeObject:[self.assetsCollection assetForIndexPath:indexPath]];
    if (collectionView == self.collectionView) {
        [self.thumbnailCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    [self _updateControls];
}


@end

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
#import "LKImagePickerControllerBundleManager.h"

#define LKImagePickerControlDetailThumbnailSize (CGSizeMake(50.0,50.0))

@interface LKImagePickerControllerDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;
@property (assign, nonatomic) CGPoint contentOffset;
@property (assign, nonatomic) BOOL scrollDirectionLeft;
@property (assign, nonatomic) BOOL scrollingByThumbnailView;
@property (strong, nonatomic) NSIndexPath* currentIndexPath;
@property (assign, nonatomic) BOOL hideBars;

@end

@implementation LKImagePickerControllerDetailViewController

#pragma mark - Privates
- (void)_updateControls
{
}
- (void)_tappedClear:(id)sender
{
}

- (void)_assetsGroupDidReload:(NSNotification*)notification
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)_toggleFullscreen
{
    self.hideBars = !self.hideBars;
    self.navigationController.navigationBar.hidden = self.hideBars;
    CGFloat alpha = self.hideBars ? 0.0 : 1.0;
    UIColor* color = self.hideBars ? UIColor.blackColor : UIColor.whiteColor;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.thumbnailCollectionView.alpha = alpha;
                         self.collectionView.backgroundColor = color;
                     }];
    [UIApplication.sharedApplication setStatusBarHidden:self.hideBars
                                          withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Privtates (Gestures)

-(void)_handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
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
    self = [super initWithNibName:nibNameOrNil bundle:LKImagePickerControllerBundleManager.bundle];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.thumbnailCollectionView.delegate = nil;
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.assetsCollection.assetsGroup.name) {
        self.title = self.assetsCollection.assetsGroup.name;
    } else {
        self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"SelectionScreen.Title"];
    }
    
    // Notifications
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_assetsGroupDidReload:)
                                               name:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_toggleFullscreen)
                                               name:LKImagePickerControllerDetailCellSingleTapNotification
                                             object:nil];

    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerDetailCell.class);
    
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:LKImagePickerControllerBundleManager.bundle]
          forCellWithReuseIdentifier:cellIdentifier];
    NSString* cellIdentifier2 = NSStringFromClass(LKImagePickerControllerSelectCell.class);
    [self.thumbnailCollectionView registerNib:[UINib nibWithNibName:cellIdentifier2 bundle:LKImagePickerControllerBundleManager.bundle]
                   forCellWithReuseIdentifier:cellIdentifier2];
    
    self.collectionView.allowsMultipleSelection = YES;
    self.thumbnailCollectionView.allowsMultipleSelection = YES;

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
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(_handleLongPress:)];
    lpgr.minimumPressDuration = 0.4;
    [self.thumbnailCollectionView addGestureRecognizer:lpgr];
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSArray* cells = [self.collectionView visibleCells];
    if (cells.count) {
        self.currentIndexPath = [self.collectionView indexPathForCell:cells[0]];
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
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
        self.currentIndexPath = nil;
    }
    
    [UIView animateWithDuration:0.75
                     animations:^{
                         self.collectionView.alpha = 1.0;
                     }];

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
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
            size = CGSizeMake(fmaxf(size.width, size.height), fminf(size.width, size.height));
        }
        return size;
    } else {
        return LKImagePickerControlDetailThumbnailSize;
    }
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
    [self.assetsManager.selectedAssets addObject:[self.assetsCollection assetForIndexPath:indexPath]];
    if (collectionView == self.collectionView) {
        [self.thumbnailCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    } else {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    [self _updateControls];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.assetsManager.selectedAssets removeObject:[self.assetsCollection assetForIndexPath:indexPath]];
    if (collectionView == self.collectionView) {
        [self.thumbnailCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    [self _updateControls];
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        LKImagePickerControllerDetailCell* detailCell = (LKImagePickerControllerDetailCell*)cell;
        [detailCell didEndDisplay];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.assetsManager.reachedMaximumOfSelections) {
        if (collectionView == self.collectionView) {
            LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[collectionView cellForItemAtIndexPath:indexPath];
            [cell alert];
        } else {
            LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[collectionView cellForItemAtIndexPath:indexPath];
            [cell alert];
        }
    }
    return !self.assetsManager.reachedMaximumOfSelections;
}

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



@end

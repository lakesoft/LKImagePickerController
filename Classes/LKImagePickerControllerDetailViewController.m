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
#import "LKImagePickerController.h"
#import "LKImagePickerControllerUtility.h"
#import "LKImagePickerCOntrollerMarkedAssetsManager.h"
#import "LKImagePickerControllerCommentManager.h"
#import "LKImagePickerControllerCheckmarkButton.h"

#define LKImagePickerControlDetailThumbnailSize (CGSizeMake(50.0,50.0))

NSString * const LKImagePickerControllerDetailViewControllerWillAppearNotification = @"LKImagePickerControllerDetailViewControllerWillAppearNotification";
NSString * const LKImagePickerControllerDetailViewControllerWillDisappearNotification = @"LKImagePickerControllerDetailViewControllerWillDisappearNotification";


@interface LKImagePickerControllerDetailViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewButtomConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;
@property (assign, nonatomic) CGPoint contentOffset;
@property (assign, nonatomic) BOOL scrollDirectionLeft;
@property (assign, nonatomic) BOOL scrollingByThumbnailView;
@property (strong, nonatomic) NSIndexPath* currentIndexPath;
@property (assign, nonatomic) BOOL hideBars;
//@property (weak, nonatomic) IBOutlet UIButton *toggleFullScreenButton;
@property (assign, nonatomic) BOOL isWhileClosing;
@property (weak, nonatomic) IBOutlet UIView *closeButton;

// navi view
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviViewBottomConstraint;

// info view (in navi View)
@property (weak, nonatomic) IBOutlet UIButton *utilityButton;
@property (weak, nonatomic) IBOutlet UILabel *assetDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *assetCommentTextField;
@property (weak, nonatomic) IBOutlet LKImagePickerControllerCheckmarkButton *checkmarkButton;

// utility views
@property (weak, nonatomic) IBOutlet UIView *topToolbarView;
@property (weak, nonatomic) IBOutlet UIView *leftSideView;
@property (weak, nonatomic) IBOutlet UIView *rightSideView;

@end

@implementation LKImagePickerControllerDetailViewController

#pragma mark - Privates
- (void)_updateControls
{
    id <LKImagePickerControllerDelegate> delegate = self.selectViewController.imagePickerController.imagePickerControllerDelegate;
    
    if ([delegate respondsToSelector:@selector(disableRightBarButtonItem3WhenNoSelected)]) {
        if ([delegate respondsToSelector:@selector(rightBarButtonItem3)]) {
            self.navigationItem.rightBarButtonItem.enabled = self.assetsManager.numberOfSelected > 0;
        }
    }
    
    if ([delegate respondsToSelector:@selector(updateDetailTopToolbarView:)]) {
        [delegate updateDetailTopToolbarView:self.topToolbarView];
    }
    if ([delegate respondsToSelector:@selector(updateDetailLeftSideView:)]) {
        [delegate updateDetailLeftSideView:self.leftSideView];
    }
    if ([delegate respondsToSelector:@selector(updateDetailRightSideView:)]) {
        [delegate updateDetailRightSideView:self.rightSideView];
    }

}
- (void)_tappedClear:(id)sender
{
}

- (void)_tappedDetailCell:(NSNotification*)notification
{
    if (self.assetCommentTextField.isFirstResponder) {
        [self.assetCommentTextField resignFirstResponder];
    } else {
        [self.assetCommentTextField becomeFirstResponder];
    }
}

- (void)_longPressedDetailCell:(NSNotification*)notification
{
    LKImagePickerControllerDetailCell* cell = notification.object;
    
    if ([self.selectViewController.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(didDetailViewCellLongPressBeganViewController:asset:)]) {
        [cell flashCompletion:^{
            [self.selectViewController.imagePickerController.imagePickerControllerDelegate didDetailViewCellLongPressBeganViewController:self asset:cell.asset];
        }];
    }
}

- (void)_assetsGroupDidReload:(NSNotification*)notification
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//- (void)_toggleFullscreen
//{
//    if (self.selectViewController.imagePickerController.fullScreenDisabled) {
//        return;
//    }
//    self.hideBars = !self.hideBars;
//    [self.assetCommentTextField resignFirstResponder];
//    NSString* imageName = self.hideBars ? @"LKImagePickerController_ButtonFullClose" : @"LKImagePickerController_ButtonFullOpen";
//    UIImage* buttonImage = [UIImage imageNamed:imageName inBundle:LKImagePickerControllerBundleManager.bundle compatibleWithTraitCollection:nil];
//    [self.toggleFullScreenButton setImage:buttonImage forState:UIControlStateNormal];
//
//
//    self.navigationController.navigationBar.hidden = self.hideBars;
//    CGFloat alpha = self.hideBars ? 0.0 : 1.0;
//    
//    self.naviViewBottomConstraint.constant = self.hideBars ? -self.naviView.bounds.size.height : 0.0;
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         self.naviView.alpha = alpha;
//                         [self.view layoutIfNeeded];
//                     }];
//    [UIApplication.sharedApplication setStatusBarHidden:self.hideBars
//                                          withAnimation:UIStatusBarAnimationFade];
//}

#pragma mark - Privtates (Gestures)

-(void)_handleThumbnailLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.thumbnailCollectionView];
    
    NSIndexPath *indexPath = [self.thumbnailCollectionView indexPathForItemAtPoint:p];
    if (indexPath){
        if ([self.selectViewController.imagePickerController.imagePickerControllerDelegate respondsToSelector:@selector(didDetailViewThubmailCellLongPressBeganViewController:asset:)]) {
            LKImagePickerControllerSelectCell* cell = [self.thumbnailCollectionView cellForItemAtIndexPath:indexPath];
            [cell flashCompletion:^{
                LKAsset* asset = [self.assetsCollection assetForIndexPath:indexPath];
                [self.selectViewController.imagePickerController.imagePickerControllerDelegate didDetailViewThubmailCellLongPressBeganViewController:self asset:asset];
            }];
        }
    }
}

-(void)_handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [self.assetCommentTextField resignFirstResponder];
}
-(void)_handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [self.assetCommentTextField becomeFirstResponder];
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

- (void)_scrollToStartpoint
{
    [self.collectionView scrollToItemAtIndexPath:self.indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    [self.thumbnailCollectionView scrollToItemAtIndexPath:self.indexPath
                                         atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                 animated:NO];
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.collectionView.alpha = 1.0;
                         self.view.backgroundColor = [UIColor blackColor]; // for keyboard transparent
                     } completion:^(BOOL finished) {
                         self.indexPath = self.indexPath;    // for .current property
                         [self updateNaviView];
                     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.assetsCollection.assetsGroup.name) {
        self.title = self.assetsCollection.assetsGroup.name;
    } else {
        self.title = [LKImagePickerControllerBundleManager localizedStringForKey:@"SelectionScreen.Title"];
    }
    
    // Side views
    id <LKImagePickerControllerDelegate> delegate = self.selectViewController.imagePickerController.imagePickerControllerDelegate;
    if ([delegate respondsToSelector:@selector(setupDetailTopToolbarView:)]) {
        [delegate setupDetailTopToolbarView:self.topToolbarView];
    }
    if ([delegate respondsToSelector:@selector(setupDetailLeftSideView:)]) {
        [delegate setupDetailLeftSideView:self.leftSideView];
    }
    if ([delegate respondsToSelector:@selector(setupDetailRightSideView:)]) {
        [delegate setupDetailRightSideView:self.rightSideView];
    }
    
    // Notifications
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_assetsGroupDidReload:)
                                               name:LKImagePickerControllerSelectViewControllerDidAssetsUpdateNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_tappedDetailCell:)
                                               name:LKImagePickerControllerDetailCellSingleTapNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_longPressedDetailCell:)
                                               name:LKImagePickerControllerDetailCellLongPressNotification
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillChangeFrame:)
                                               name:UIKeyboardWillChangeFrameNotification
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];

    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerDetailCell.class);
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:LKImagePickerControllerBundleManager.bundle]
          forCellWithReuseIdentifier:cellIdentifier];
    
    NSString* cellIdentifier2 = NSStringFromClass(LKImagePickerControllerSelectCell.class);
    [self.thumbnailCollectionView registerNib:[UINib nibWithNibName:cellIdentifier2 bundle:LKImagePickerControllerBundleManager.bundle]
                   forCellWithReuseIdentifier:cellIdentifier2];

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(_handleThumbnailLongPress:)];
    lpgr.minimumPressDuration = 0.3;
    [self.thumbnailCollectionView addGestureRecognizer:lpgr];

    UISwipeGestureRecognizer *swgr1 = [[UISwipeGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(_handleSwipeDown:)];
    swgr1.direction = UISwipeGestureRecognizerDirectionDown;
    [self.naviView addGestureRecognizer:swgr1];

    UISwipeGestureRecognizer *swgr2 = [[UISwipeGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(_handleSwipeUp:)];
    swgr2.direction = UISwipeGestureRecognizerDirectionUp;
    [self.naviView addGestureRecognizer:swgr2];

//    self.collectionView.alpha = 0.0;
//    [self performSelector:@selector(_scrollToStartpoint) withObject:nil afterDelay:0.1];
    
    if ([delegate respondsToSelector:@selector(rightBarButtonItem3)]) {
        self.navigationItem.rightBarButtonItem = delegate.rightBarButtonItem3;
    }

    [self _updateControls];
    
    self.assetCommentTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:[LKImagePickerControllerBundleManager localizedStringForKey:@"Comment.Placeholder"]
                                    attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:0.8] }];
    
    // navi view animation
//    self.naviView.alpha = 0.0;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.naviView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//    }];
//    
//    if (self.selectViewController.imagePickerController.doOpenKeyboardInDetailView) {
//        [self.assetCommentTextField becomeFirstResponder];
//    }
    
//    self.naviView.alpha = 0.0;
//    [UIView animateWithDuration:1.0 animations:^{
//        self.naviView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//    }];
//    self.thumbnailCollectionView.alpha = 0.0;
//    [UIView animateWithDuration:1.5 animations:^{
//        self.thumbnailCollectionView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//    }];
    if (self.selectViewController.imagePickerController.doOpenKeyboardInDetailView) {
        [self.assetCommentTextField becomeFirstResponder];
    }

    self.view.backgroundColor = UIColor.clearColor;
    
    if ([delegate respondsToSelector:@selector(utilityButtonImageState:)]) {
        UIImage* image = [delegate utilityButtonImageState:UIControlStateNormal];
        [self.utilityButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerDetailViewControllerWillAppearNotification object:self userInfo:nil];
    self.collectionView.alpha = 0.0;
    [self performSelector:@selector(_scrollToStartpoint) withObject:nil afterDelay:0.1];
    [UIApplication.sharedApplication setStatusBarHidden:YES
                                          withAnimation:UIStatusBarAnimationFade];
    self.topToolbarView.alpha = 0.0;
    self.leftSideView.alpha = 0.0;
    self.rightSideView.alpha = 0.0;
    self.closeButton.alpha = 0.0;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        self.topToolbarView.alpha = 1.0;
        self.leftSideView.alpha = 1.0;
        self.rightSideView.alpha = 1.0;
        self.closeButton.alpha = 1.0;
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerDetailViewControllerWillDisappearNotification object:self userInfo:nil];
    [UIApplication.sharedApplication setStatusBarHidden:NO
                                          withAnimation:UIStatusBarAnimationFade];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIScrollViewDelegate
//- (NSInteger)_indexForIndexPath:(NSIndexPath*)indexPath
//{
//    NSInteger index = 0;
//    for (NSInteger section=0; section < indexPath.section; section++) {
//        LKAssetsCollectionEntry* entry = self.assetsCollection.entries[section];
//        index += entry.assets.count;
//    }
//    index += indexPath.item;
//    
//    return index;
//}

//- (NSIndexPath*)_indexPathFromIndex:(NSInteger)index
//{
//    NSInteger section = 0;
//    NSInteger item = 0;
//    NSInteger count = index;
//    while (count) {
//        NSInteger numberOfEntries = self.assetsCollection.entries.count;
//        if (numberOfEntries <= section) {
//            return nil;
//        }
//        LKAssetsCollectionEntry* entry = self.assetsCollection.entries[section];
//        NSInteger numberOfAssets = entry.assets.count;
//        if (count < numberOfAssets) {
//            item = count;
//            break;
//        }
//        count -= numberOfAssets;
//        section++;
//    }
//    return [NSIndexPath indexPathForItem:item inSection:section];
//}


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
        CGFloat maxX = self.thumbnailCollectionView.contentSize.width - self.thumbnailCollectionView.bounds.size.width;
        thumbnailContentOffset.x = fmin(thumbnailContentOffset.x, maxX);
        self.thumbnailCollectionView.contentOffset = thumbnailContentOffset;
    }

    if (fmod(self.collectionView.contentOffset.x, size.width) == 0) {
        CGPoint p = self.contentOffset;
        p.x += size.width / 2.0;
        p.y += size.height / 2.0;
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath) {
            self.indexPath = indexPath;

            [self.thumbnailCollectionView scrollToItemAtIndexPath:self.indexPath
                                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                         animated:YES];
            [self updateNaviView];
        }
        self.scrollingByThumbnailView = NO;
    }
    
}

#pragma mark - Sub header
- (void)updateNaviView
{
    // update navi view
    LKAsset* asset = [self.assetsCollection assetForIndexPath:self.indexPath];
    self.assetDateLabel.text = asset.date != nil ? [LKImagePickerControllerUtility formattedDateTimeStringForDate:asset.date] : @"";
    self.assetCommentTextField.text = asset.commentString;
    LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    self.checkmarkButton.checked = cell.checked;
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
    LKAsset* asset = [self.assetsCollection assetForIndexPath:indexPath];

    if (collectionView == self.collectionView) {
        LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKImagePickerControllerDetailCell.class)
                                                                                forIndexPath:indexPath];
        cell.asset = asset;
        cell.checked = [self.assetsManager containsSelectedAsset:asset];
        cell.viewController = self;
        cell.aspectFill = self.aspectFill;
        return cell;
    } else {
        LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKImagePickerControllerSelectCell.class)
                                                                                                                                forIndexPath:indexPath];
        cell.asset = asset;
        cell.checkmarkUserInteractionEnabled = NO;
        cell.checkmarkHiddenMode = YES; // call me at first !
        cell.current = [self.indexPath isEqual:indexPath];
        cell.checked = [self.assetsManager containsSelectedAsset:asset];
        return cell;
    }
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.thumbnailCollectionView) {
        self.scrollingByThumbnailView = YES;
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.assetsManager deselectAsset:[self.assetsCollection assetForIndexPath:indexPath]];
//    if (collectionView == self.thumbnailCollectionView) {
//    }
//    [self _updateControls];
//}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        LKImagePickerControllerDetailCell* detailCell = (LKImagePickerControllerDetailCell*)cell;
        [detailCell didEndDisplay];
    }
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.assetsManager.reachedMaximumOfSelections) {
//        if (collectionView == self.collectionView) {
//            LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[collectionView cellForItemAtIndexPath:indexPath];
//            [cell alert];
//        } else {
//            LKImagePickerControllerSelectCell* cell = (LKImagePickerControllerSelectCell*)[collectionView cellForItemAtIndexPath:indexPath];
//            [cell alert];
//        }
//    }
//    return !self.assetsManager.reachedMaximumOfSelections;
//}

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


#pragma mark - Actions
- (void)toggleCheckmark
{
    LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    
    cell.checked = !cell.checked;
    
    if (cell.checked) {
        if (self.assetsManager.reachedMaximumOfSelections) {
            [self.checkmarkButton alert];
            cell.checked = NO;
        } else {
            [self.assetsManager selectAsset:[self.assetsCollection assetForIndexPath:self.indexPath]];
            [self _updateControls];
        }
    } else {
        [self.assetsManager deselectAsset:[self.assetsCollection assetForIndexPath:self.indexPath]];
        [self _updateControls];
    }
    
    LKImagePickerControllerDetailCell* detailCell = (LKImagePickerControllerDetailCell*)[self.thumbnailCollectionView cellForItemAtIndexPath:self.indexPath];
    detailCell.checked = cell.checked;
    
    NSDictionary* userInfo = @{LKImagePickerControllerAssetsManagerKeyIndexPaths:@[self.indexPath],
                               LKImagePickerControllerAssetsManagerKeyNumberOfSelections:@(self.assetsManager.numberOfSelected)};
    [NSNotificationCenter.defaultCenter postNotificationName:LKImagePickerControllerAssetsManagerDidSelectNotification
                                                      object:self
                                                    userInfo:userInfo];
}
- (IBAction)checkmarkTouchded:(id)sender event:(UIEvent*)event
{
    [self toggleCheckmark];
}

//- (IBAction)onToggleFullScreen:(id)sender {
//    [self _toggleFullscreen];
//}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    LKImagePickerControllerSelectCell* cell;
    
    cell = (LKImagePickerControllerSelectCell*)[self.thumbnailCollectionView cellForItemAtIndexPath:_indexPath];
    cell.current = NO;
    
    _indexPath = indexPath;


    cell = (LKImagePickerControllerSelectCell*)[self.thumbnailCollectionView cellForItemAtIndexPath:_indexPath];
    cell.current = YES;
}

- (IBAction)onCloseButton:(id)sender {
    self.isWhileClosing = YES;
    [self.assetCommentTextField resignFirstResponder];
    
    if (self.selectViewController.imagePickerController.navigationBarHidden) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)onUtilityButton:(id)sender {
    id <LKImagePickerControllerDelegate> delegate = self.selectViewController.imagePickerController.imagePickerControllerDelegate;
    
    if ([delegate respondsToSelector:@selector(onUtilityButton:)]) {
        [delegate onUtilityButton:sender];
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    LKAsset* asset = [self.assetsCollection assetForIndexPath:self.indexPath];
    asset.commentString = str;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onCloseButton:nil];
//    self.checkmarkButton.checked = !self.checkmarkButton.checked;
//    [self toggleCheckmark];
}

#pragma mark - Keyboard management
- (void)keyboardWillChangeFrame:(NSNotification*)notification
{
    if (self.isWhileClosing) {
        return;
    }

    NSValue* keyBoardValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
//    NSLog(@"%@", keyBoardValue);
    CGRect keyBoardFrame = keyBoardValue.CGRectValue;
//    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    CGFloat viewHeight = self.view.bounds.size.height + self.view.frame.origin.y + self.selectViewController.imagePickerController.detailNaviViewOffset;
    
    NSNumber* duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
//    CGFloat constant = screenHeight - keyBoardFrame.origin.y;
    CGFloat constant = viewHeight - keyBoardFrame.origin.y;
    self.naviViewBottomConstraint.constant = constant;
    self.collectionViewButtomConstraint.constant = constant;
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.aspectFill = YES;
    LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    cell.aspectFill = YES;
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    if (self.isWhileClosing) {
        return;
    }
    NSNumber* duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    self.naviViewBottomConstraint.constant = 0;
    self.collectionViewButtomConstraint.constant = 0;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    self.aspectFill = NO;
    LKImagePickerControllerDetailCell* cell = (LKImagePickerControllerDetailCell*)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    cell.aspectFill = NO;

}

// MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return NO;
}

// MARK: - Computed properties
- (LKAsset*)currentAsset {
    return [self.assetsCollection assetForIndexPath:self.indexPath];
}

@end

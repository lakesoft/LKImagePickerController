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

@interface LKImagePickerControllerDetailViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *collectionView;
@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;

@end

@implementation LKImagePickerControllerDetailViewController

#pragma mark - Privates
- (void)_updateControls
{
    NSLog(@"updated");
}

#pragma mark - Basics
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* cellIdentifier = NSStringFromClass(LKImagePickerControllerDetailCell.class);
    
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil]
          forCellWithReuseIdentifier:cellIdentifier];
    NSString* cellIdentifier2 = NSStringFromClass(LKImagePickerControllerSelectCell.class);
    [self.thumbnailCollectionView registerNib:[UINib nibWithNibName:cellIdentifier2 bundle:nil]
                   forCellWithReuseIdentifier:cellIdentifier2];
    
    self.collectionView.allowsMultipleSelection = YES;
    self.thumbnailCollectionView.allowsMultipleSelection = YES;

    [self.collectionView reloadData];
    [self.thumbnailCollectionView reloadData];
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
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

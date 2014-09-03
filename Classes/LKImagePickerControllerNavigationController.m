//
//  LKImagePickerControllerNavigationController.m
//  Pods
//
//  Created by Hiroshi Hashiguchi on 2014/09/04.
//
//

#import "LKImagePickerControllerNavigationController.h"

@interface LKImagePickerControllerNavigationController ()

@end

@implementation LKImagePickerControllerNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                              target:self
                                                                              action:@selector(_tappedClose:)];
        rootViewController.navigationItem.leftBarButtonItem = item;
    }
    return self;
}

- (void)_tappedClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

@end

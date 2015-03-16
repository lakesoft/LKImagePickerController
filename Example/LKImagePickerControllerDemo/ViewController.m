//
//  ViewController.m
//  LKImagePickerControllerDemo
//
//  Created by Hiroshi Hashiguchi on 2014/05/31.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "ViewController.h"
#import "LKImagePickerController.h"

@interface ViewController () <LKImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    LKImagePickerController* controller = [[LKImagePickerController alloc] init];
    controller.imagePickerControllerDelegate = self;
//    controller.tintColor = [UIColor colorWithRed:0.078 green:0.67 blue:0.23 alpha:1.000];
    controller.maximumOfSelections = 20;
    [self presentViewController:controller animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)openPicker:(id)sender {
}

- (void)imagePickerController:(LKImagePickerController *)imagePickerController didFinishWithAssets:(NSArray *)selectedAssets {
    
}

- (BOOL)canSelectGroups
{
    return NO;
}

@end

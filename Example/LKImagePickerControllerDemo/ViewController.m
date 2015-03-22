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
@property (nonatomic, strong) LKImagePickerController* controller;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.controller = [[LKImagePickerController alloc] init];
    self.controller.imagePickerControllerDelegate = self;
//    controller.tintColor = [UIColor colorWithRed:0.078 green:0.67 blue:0.23 alpha:1.000];
    self.controller.maximumOfSelections = 20;
    [self presentViewController:self.controller animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)openPicker:(id)sender {
}

- (void)imagePickerController:(LKImagePickerController *)imagePickerController didFinishWithAssets:(NSArray *)selectedAssets {
    
}

//- (UIBarButtonItem*)leftBarButtonItem
//{
//    return nil;
//}
- (void)_on3
{
    [self.controller displayMainScreenAnimated:YES];
}

- (UIBarButtonItem*)rightBarButtonItem3
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                         target:self
                                                         action:@selector(_on3)];
}
- (BOOL)disableRightBarButtonItem3WhenNoSelected
{
    return YES;
}

- (BOOL)canSelectGroups
{
    return NO;
}

@end

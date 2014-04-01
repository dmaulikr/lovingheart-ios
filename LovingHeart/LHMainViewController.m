//
//  LHMainViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/2.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHMainViewController.h"

@implementation LHMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setDelegate:self];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
  static UIViewController *previousController = nil;
  if (previousController == viewController) {
    // the same tab was tapped a second time
    if ([viewController isKindOfClass:[UINavigationController class]]) {
      UINavigationController *navigationController = (UINavigationController *)viewController;
      if (navigationController.viewControllers.count > 0) {
        if ([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[UITableViewController class]]) {
          UITableViewController *tableViewController = [navigationController.viewControllers objectAtIndex:0];
          if ([tableViewController.tableView numberOfSections] >= 1 && [tableViewController.tableView numberOfRowsInSection:0] >= 1) {
            [tableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
          }
        }
      }
    }

  }
  previousController = viewController;
}


@end

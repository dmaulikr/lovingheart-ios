//
//  LHLoginViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/27.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHLoginViewController.h"
#import <SVProgressHUD.h>

@implementation LHLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red"]];
//  UILabel *logoLabel = [[UILabel alloc] init];
//  [logoLabel setText:@"LovingHeart"];
//  [logoLabel setFont:[UIFont boldSystemFontOfSize:44]];
//  logoLabel.shadowOffset = CGSizeMake(1, 1);
//  logoLabel.shadowColor = [UIColor grayColor];
//  [logoLabel sizeToFit];
//  [logoLabel setTextColor:[UIColor colorWithHue:0.026 saturation:0.966 brightness:0.922 alpha:1]];
//  self.logInView.logo = logoLabel;
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordpress-logo-red-text"]];
  self.logInView.logo = imageView;
  
  self.delegate = self;
}

#pragma mark - PFLogInViewControllerDelegate

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
  NSLog(@"didFailToLogInWithError: %@", error);
  
  [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:@"error"]];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [logInController dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  LHLoginViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/27.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHLoginViewController.h"
#import <SVProgressHUD.h>
#import "LHSignUpViewController.h"

@implementation LHLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
      self.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.signUpController = [[LHSignUpViewController alloc] init];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red"]];
  self.logInView.usernameField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red-2"]];
  self.logInView.passwordField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red-2"]];
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lovingheart_black_red_clear_logo"]];
  self.logInView.logo = imageView;
  if (!self.delegate) {
      self.delegate = self;
  }
  
  self.logInView.passwordForgottenButton.hidden = YES;
  
}

#pragma mark - PFLogInViewControllerDelegate

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Login Success. %@", user.email]];
  [logInController dismissViewControllerAnimated:YES completion:nil];
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

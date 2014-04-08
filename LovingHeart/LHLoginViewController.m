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
#import <UIAlertView+BlocksKit.h>

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
  
  [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileRefreshNotification object:nil];
  
  [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Login Success. %@", user.email]];
  [logInController dismissViewControllerAnimated:YES completion:nil];
  
  // Check and ask user to sign up
  BOOL hasAskUserNotification = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultHasBeenAskUser];
  if (hasAskUserNotification) {
    [UIAlertView bk_showAlertViewWithTitle:@"Send message" message:@"Let LovingHeart can push message to me." cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"OK", @"No", nil] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
      NSLog(@"Ask and click: %i", (int)buttonIndex);
      switch (buttonIndex) {
        case 0:
          break;
        case 1:
          [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultHasBeenAskUser];
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultUserWantPushNotification];
          [[NSUserDefaults standardUserDefaults] synchronize];
          break;
        case 2:
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultHasBeenAskUser];
          [[NSUserDefaults standardUserDefaults] synchronize];
          break;
        default:
          break;
      }
    }];
  }
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

//
//  LHUserViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/1.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHCurrentUserViewController.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "LHLoginViewController.h"
#import "LHSignUpViewController.h"
#import "SVProgressHUD.h"

@interface LHCurrentUserViewController ()

@end

@implementation LHCurrentUserViewController

NSString* const kUserProfileRefreshNotification = @"kUserProfileRefreshNotification";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.askUserLoginView.contentSize = CGSizeMake(self.askUserLoginView.width, self.view.height);
  
  [self resetUser];
  [self queryUserInfo];
  
  [self.loginActionButton bk_addEventHandler:^(id sender) {
    LHLoginViewController *loginViewController = [[LHLoginViewController alloc] init];
    loginViewController.delegate = self;
    loginViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;;

    [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
  } forControlEvents:UIControlEventTouchUpInside];
  
  __block LHCurrentUserViewController *__self = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:kUserProfileRefreshNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    [__self resetUser];
    [__self queryUserInfo];
  }];
}

- (void)resetUser {
  if ([LHUser currentUser]) {
    self.askUserLoginView.hidden = YES;
    self.userProfileScrollView.hidden = NO;
    LHUser *currentUser = [[LHUser alloc] init];
    [currentUser setObjectId:[PFUser currentUser].objectId];
    [self setUser:currentUser];
  } else {
    self.userProfileScrollView.hidden = YES;
    self.askUserLoginView.hidden = NO;
  }
}

#pragma mark - PFLogInViewControllerDelegate

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Login Success. %@", user.email]];
  [logInController dismissViewControllerAnimated:YES completion:nil];
  [self resetUser];
  [self queryUserInfo];
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

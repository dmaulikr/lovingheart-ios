//
//  LHSignUpViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/3.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHSignUpViewController.h"

@implementation LHSignUpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red"]];
  self.signUpView.usernameField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red-2"]];
  self.signUpView.passwordField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red-2"]];
  self.signUpView.emailField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-red-2"]];
  
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lovingheart_black_red_clear_logo"]];
  self.signUpView.logo = imageView;
  
}

@end

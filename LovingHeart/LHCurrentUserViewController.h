//
//  LHUserViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/1.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHUserProfileViewController.h"


@interface LHCurrentUserViewController : LHUserProfileViewController
<
  PFLogInViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *askUserLoginView;
@property (weak, nonatomic) IBOutlet UIButton *loginActionButton;

@end
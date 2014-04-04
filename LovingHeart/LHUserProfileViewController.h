//
//  LHUserProfileViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/4.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHUser.h"
#import <AFNetworking/AFNetworking.h>

@interface LHUserProfileViewController : UIViewController

@property (nonatomic, strong) LHUser *user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfGraphicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfEnergyLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *userProfileScrollView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)resetUser;
- (void)queryUserInfo;

@end

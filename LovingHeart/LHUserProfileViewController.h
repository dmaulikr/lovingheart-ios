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
<
  UITableViewDataSource,
  UITableViewDelegate
>

@property (nonatomic, strong) LHUser *user;
@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) NSMutableArray *reportWords;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfGraphicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfEnergyLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *userProfileScrollView;
@property (nonatomic, strong) UITableView *userReportTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

- (void)resetUser;
- (void)queryUserInfo;

@end
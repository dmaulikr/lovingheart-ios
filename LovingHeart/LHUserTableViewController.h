//
//  LHUserTableViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/15.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHUserTableViewController : UITableViewController

@property (nonatomic, strong) LHUser *user;
@property (nonatomic, strong) LHUserImpact *userImpact;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

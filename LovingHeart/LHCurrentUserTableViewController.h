//
//  LHCurrentUserTableViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCurrentUserTableViewController : PFQueryTableViewController

@property (nonatomic, strong) LHUserImpact *userImpact;

@property (nonatomic, assign) CGFloat previousScrollViewYOffset;

@end

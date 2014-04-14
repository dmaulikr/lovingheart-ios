//
//  LHUserCollectionsViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/14.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHUser.h"
#import <AFNetworking/AFNetworking.h>

@interface LHUserCollectionsViewController : UICollectionViewController

@property (nonatomic, strong) LHUser *user;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

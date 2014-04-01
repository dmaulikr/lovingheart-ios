//
//  LHUserViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/1.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHUserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfGraphicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfEnergyLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

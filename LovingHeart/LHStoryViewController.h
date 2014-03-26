//
//  LHStoryViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/25.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHStory.h"

@interface LHStoryViewController : UIViewController

@property (nonatomic, strong) LHStory *story;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyDateLabel;



@end

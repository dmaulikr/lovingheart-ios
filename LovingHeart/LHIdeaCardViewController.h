//
//  LHIdeaCardViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHIdea.h"

@interface LHIdeaCardViewController : UIViewController

@property (nonatomic, strong) LHIdea *idea;
@property (weak, nonatomic) IBOutlet UIImageView *ideaCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaContentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *readStoriesButton;
@property (weak, nonatomic) IBOutlet UIButton *shareStoryButton;

@end

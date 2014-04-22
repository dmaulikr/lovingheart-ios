//
//  LHStoryReviewViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/11.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHStoryReviewViewController : UIViewController

@property (nonatomic, strong) LHEvent *encourage;
@property (nonatomic, strong) LHStory *story;
@property (nonatomic, strong) NSArray *encourageList;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButtonItem;


@property (weak, nonatomic) IBOutlet UITextField *reviewTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *oneStarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *twoStarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *threeStarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fourStarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fiveStarButtonItem;


@end

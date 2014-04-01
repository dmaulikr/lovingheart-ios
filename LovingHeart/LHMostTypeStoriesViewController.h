//
//  StoryTimelineViewController.h
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoriesViewController.h"

@interface LHMostTypeStoriesViewController : LHStoriesViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchButtonItem;
@property (weak, nonatomic) IBOutlet UISegmentedControl *storiesTypeSegmentedControl;

@end

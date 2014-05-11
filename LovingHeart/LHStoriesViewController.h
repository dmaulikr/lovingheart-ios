//
//  StoryTimelineViewController.h
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <Parse/Parse.h>
#import "LHStory.h"

typedef enum {
  kStories_Latest = 0,
  kStories_Popular = 1,
  kStories_Anonymous = 2
} StoriesType;


@interface LHStoriesViewController : PFQueryTableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchButtonItem;
@property (weak, nonatomic) IBOutlet UISegmentedControl *storiesTypeSegmentedControl;

@property (nonatomic, assign) StoriesType storiesType;


@property (nonatomic, assign) CGFloat previousScrollViewYOffset;

@end

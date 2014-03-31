//
//  StoryTimelineViewController.h
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoriesViewController.h"

@interface LHMostTypeStoriesViewController : LHStoriesViewController

typedef enum {
  kStories_Latest = 0,
  kStories_Popular = 1,
  kStories_Anonymous = 2
} StoriesType;

@property (nonatomic, assign) StoriesType storiesType;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchButtonItem;

@end

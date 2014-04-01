//
//  StoryTimelineViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/23.
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


@property (nonatomic, assign) StoriesType storiesType;

@end

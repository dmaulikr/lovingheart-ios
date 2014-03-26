//
//  StoryTimelineMostReviewsViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHMostReviewsStoriesViewController.h"

@implementation LHMostReviewsStoriesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = NSLocalizedString(@"Most Rated", @"Most Rated");
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHStory query];
  
  [query includeKey:@"StoryTeller"];
  [query includeKey:@"StoryTeller.avatar"];
  [query includeKey:@"graphicPointer"];
  
  // If no objects are loaded in memory, we look to the cache first to fill the table
  // and then subsequently do a query against the network.
  if (self.objects.count == 0) {
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  }
  
  [query orderByDescending:@"reviewImpact"];
  
  return query;
}


@end

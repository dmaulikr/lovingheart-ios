//
//  StoryTimelineMostReviewsViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "StoryTimelineMostReviewsViewController.h"

@implementation StoryTimelineMostReviewsViewController

- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
  
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

//
//  StoryTimelineViewController.m
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHMostRecentStoriesViewController.h"
#import <BlocksKit/BlocksKit.h>
#import <UIBarButtonItem+BlocksKit.h>

@interface LHMostRecentStoriesViewController ()

@end

@implementation LHMostRecentStoriesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = NSLocalizedString(@"Latest Stories", @"Latest Stories");
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
  
  [query orderByDescending:@"createdAt"];
  
  return query;
}


@end

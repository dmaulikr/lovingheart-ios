//
//  StoryTimelineViewController.m
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "MostRecentStoriesViewController.h"
#import <BlocksKit/BlocksKit.h>
#import <UIBarButtonItem+BlocksKit.h>

@interface MostRecentStoriesViewController ()

@end

@implementation MostRecentStoriesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = NSLocalizedString(@"Latest Stories", @"Latest Stories");
  
  [_composeBarButtonItem setTarget:self];
  [_composeBarButtonItem setAction:@selector(composePressed:)];
  
  UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemCompose handler:^(id sender) {
    NSLog(@"Compose button blocksKit pressed.");
  }];
  [self.navigationItem setRightBarButtonItem:composeItem];
}

- (void)composePressed:(id)buttonItem {
  NSLog(@"Compose button pressed.");
}

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
  
  [query orderByDescending:@"createdAt"];
  
  return query;
}


@end

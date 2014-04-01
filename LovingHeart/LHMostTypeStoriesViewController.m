//
//  StoryTimelineViewController.m
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHMostTypeStoriesViewController.h"
#import <BlocksKit/BlocksKit.h>
#import <UIBarButtonItem+BlocksKit.h>
#import "LHStoryPickViewController.h"

@interface LHMostTypeStoriesViewController ()

@end

@implementation LHMostTypeStoriesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = NSLocalizedString(@"Latest Stories", @"Latest Stories");
  
  [_storiesTypeSegmentedControl addTarget:self action:@selector(storiesSegmented:) forControlEvents:UIControlEventValueChanged];
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
  switch (self.storiesType) {
    case 2:
      [query whereKey:@"status" equalTo:@"anonymous"];
      [query orderByDescending:@"createdAt"];
      self.title = NSLocalizedString(@"Anonymous Stories", @"Anonymous Stories");
      break;
    case 1:
      [query whereKey:@"status" notEqualTo:@"anonymous"];
      [query orderByDescending:@"reviewImpact"];
      self.title = NSLocalizedString(@"Popluar Stories", @"Popluar Stories");
      break;
    case 0:
    default:
      [query whereKey:@"status" notEqualTo:@"anonymous"];
      [query orderByDescending:@"createdAt"];
      self.title = NSLocalizedString(@"Latest Stories", @"Latest Stories");
      break;
  }
  
  
  return query;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [super prepareForSegue:segue sender:sender];
  if ([segue.identifier isEqualToString:@"storiesPicker"]) {
    UINavigationController *rootViewController = (UINavigationController *)segue.destinationViewController;
    
    LHStoryPickViewController *storyPicker = (LHStoryPickViewController *)rootViewController.viewControllers[0];
    [storyPicker setSelected:[NSIndexSet indexSetWithIndex:self.storiesType]];
    [storyPicker setDidSelectedRowAtIndexPath:^(NSIndexPath *indexPath) {
      NSLog(@"Did select %li", (long)indexPath.row);
      
      
      StoriesType newType;
      switch (indexPath.row) {
        case 0:
          newType = kStories_Latest;
          break;
        case 1:
          newType = kStories_Popular;
          break;
        case 2:
          newType = kStories_Anonymous;
          break;
        default:
          newType = kStories_Latest;
          break;
      }
      if (newType != self.storiesType) {
        self.storiesType = newType;
        [self loadObjects];
      }
    }];
  }
}

- (void)storiesSegmented:(id)sender {
  UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
  StoriesType newType;
  switch (segmentedControl.selectedSegmentIndex) {
    case 0:
      newType = kStories_Latest;
      break;
    case 1:
      newType = kStories_Popular;
      break;
    case 2:
      newType = kStories_Anonymous;
      break;
    default:
      newType = kStories_Latest;
      break;
  }
  if (newType != self.storiesType) {
    self.storiesType = newType;
    [self loadObjects];
  }
}


@end

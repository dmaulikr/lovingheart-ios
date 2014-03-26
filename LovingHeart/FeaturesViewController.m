//
//  ViewController.m
//  LovingHeart
//
//  Created by zeta on 2014/1/12.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "FeaturesViewController.h"
#import "LHIdea.h"
#import <stdlib.h>
#import <time.h>
#import "LHIdeaCardView.h"

@interface FeaturesViewController ()

@end

@implementation FeaturesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.title = NSLocalizedString(@"Today", @"Show today");
  
  PFQuery *query = [LHIdea query];
  [query whereKey:@"status" notContainedIn:[NSArray arrayWithObjects:@"close", nil]];
  [query orderByDescending:@"doneCount"];
  [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      srandom(time(nil));
      int randomIndex = (int)(random() % objects.count);
      LHIdea *randomIdea = [objects objectAtIndex:randomIndex];
      
      __block int frameTop = 0;
      
      LHIdea *latestIdea = [objects objectAtIndex:objects.count - 1];
      dispatch_async(dispatch_get_main_queue(), ^{
        LHIdeaCardView *latestIdeaTextView = [[LHIdeaCardView alloc] init];
        [latestIdeaTextView.ideaNameLabel setText:latestIdea.Name];
        [latestIdeaTextView.ideaDescriptionLabel setText:latestIdea.Description];
        [latestIdeaTextView.cardTitleLabel setText:NSLocalizedString(@"Latest Idea", @"Latest Idea")];
        latestIdeaTextView.frame = CGRectMake(latestIdeaTextView.frame.origin.x, frameTop, latestIdeaTextView.frame.size.width, latestIdeaTextView.frame.size.height);
        frameTop += latestIdeaTextView.frame.size.height;
        [self.scrollView addSubview:latestIdeaTextView];
        [self.scrollView setContentSize:self.scrollView.bounds.size];
      });
      
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Random idea name: %@", randomIdea.Name);
        
        LHIdeaCardView *ideaTextView = [[LHIdeaCardView alloc] init];
        [ideaTextView.ideaNameLabel setText:randomIdea.Name];
        [ideaTextView.ideaDescriptionLabel setText:randomIdea.Description];
        [ideaTextView.cardTitleLabel setText:NSLocalizedString(@"Random Idea", @"Random Idea")];
        ideaTextView.frame = CGRectMake(ideaTextView.frame.origin.x, frameTop, ideaTextView.frame.size.width, ideaTextView.frame.size.height);
        frameTop += ideaTextView.frame.size.height;
        [self.scrollView addSubview:ideaTextView];
        [self.scrollView setContentSize:self.scrollView.bounds.size];
      });
      
      [self.scrollView setPagingEnabled:YES];
      NSLog(@"Successfully retrieved %lu idea.", (unsigned long)objects.count);
      for (LHIdea* eachIdea in objects) {
        NSLog(@"Each idea name: %@", eachIdea.Name);
        NSLog(@"Each idea done Count: %i", [eachIdea.doneCount intValue]);
      }
    } else {
      NSLog(@"Error: %@ %@", error, error.userInfo);
    }
  }];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

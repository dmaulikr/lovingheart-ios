//
//  ViewController.m
//  LovingHeart
//
//  Created by zeta on 2014/1/12.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "FeaturesViewController.h"
#import "Idea.h"
#import <stdlib.h>
#import <time.h>

@interface FeaturesViewController ()

@end

@implementation FeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"Today", @"Show today");
  
  PFQuery *query = [Idea query];
  [query whereKey:@"status" notContainedIn:[NSArray arrayWithObjects:@"close", nil]];
  [query orderByDescending:@"doneCount"];
  [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      srandom(time(NULL));
      int randomIndex = random() % objects.count;
      Idea *randomIdea = [objects objectAtIndex:randomIndex];
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Random idea name: %@", randomIdea.Name);
        UITextView *ideaTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [ideaTextView setText:randomIdea.Name];
        [self.scrollView addSubview:ideaTextView];

      });
      
      NSLog(@"Successfully retrieved %d idea.", objects.count);
      for (Idea* eachIdea in objects) {
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

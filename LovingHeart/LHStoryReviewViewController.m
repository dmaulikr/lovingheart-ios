//
//  LHStoryReviewViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/11.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoryReviewViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface LHStoryReviewViewController ()

@end

@implementation LHStoryReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  _encourage = [[LHEvent alloc] init];
  
  self.postButtonItem.target = self;
  self.postButtonItem.action = @selector(postButtonItemPressed:);
  
  self.cancelButtonItem.target = self;
  self.cancelButtonItem.action = @selector(cancelButtonPressed:);
  
  self.oneStarButtonItem.target = self;
  self.oneStarButtonItem.action = @selector(oneStarButtonItemPressed:);
  
  self.twoStarButtonItem.target = self;
  self.twoStarButtonItem.action = @selector(twoStarButtonItemPressed:);
  
  self.threeStarButtonItem.target = self;
  self.threeStarButtonItem.action = @selector(threeStarButtonItemPressed:);
  
  self.fourStarButtonItem.target = self;
  self.fourStarButtonItem.action = @selector(fourStarButtonItemPressed:);
  
  self.fiveStarButtonItem.target = self;
  self.fiveStarButtonItem.action = @selector(fiveStarButtonItemPressed:);
  
  PFQuery *eventQUery = [LHEvent query];
  [eventQUery whereKey:@"user" equalTo:[LHUser currentUser]];
  [eventQUery whereKey:@"action" equalTo:@"review_story"];
  [eventQUery whereKey:@"story" equalTo:self.story];
  __block LHStoryReviewViewController *__self = self;
  [SVProgressHUD showWithStatus:@"Loading"];
  [eventQUery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    [SVProgressHUD dismiss];
    if (!error && object) {
      LHEvent *foundEvent = (LHEvent *)object;
      __self.reviewTextField.text = foundEvent[@"description"];
      [__self multiButtonPressed:foundEvent.value];
      
      __self.encourage = foundEvent;
    }
  }];
  
  [self.reviewTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)multiButtonPressed:(NSNumber *)value {
  [self.oneStarButtonItem setImage:[UIImage imageNamed:@"726-star"]];
  [self.twoStarButtonItem setImage:[UIImage imageNamed:@"726-star"]];
  [self.threeStarButtonItem setImage:[UIImage imageNamed:@"726-star"]];
  [self.fourStarButtonItem setImage:[UIImage imageNamed:@"726-star"]];
  [self.fiveStarButtonItem setImage:[UIImage imageNamed:@"726-star"]];
  
  if (value.intValue >= 1) {
    [self.oneStarButtonItem setImage:[UIImage imageNamed:@"726-star-selected"]];
  }
  if (value.intValue >= 2) {
    [self.twoStarButtonItem setImage:[UIImage imageNamed:@"726-star-selected"]];
  }
  if (value.intValue >= 3) {
    [self.threeStarButtonItem setImage:[UIImage imageNamed:@"726-star-selected"]];
  }
  if (value.intValue >= 4) {
    [self.fourStarButtonItem setImage:[UIImage imageNamed:@"726-star-selected"]];
  }
  if (value.intValue >= 5) {
    [self.fiveStarButtonItem setImage:[UIImage imageNamed:@"726-star-selected"]];
  }
  
  self.encourage.value = value;
}

- (void)postButtonItemPressed:(id)sender {
  [self.encourage setUser:[LHUser currentUser]];
  [self.encourage setObject:self.reviewTextField.text forKey:@"description"];
  if (self.story) {
    [self.encourage setObject:self.story forKey:@"story"];
  }
  [self.encourage setObject:@"review_story" forKey:@"action"];
  [SVProgressHUD showWithStatus:@"Posting"];
  [self.encourage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      [SVProgressHUD showSuccessWithStatus:@"Done"];
      
      PFQuery *pushQuery = [PFInstallation query];
      
      NSMutableArray *pushToUsers = [[NSMutableArray alloc] init];
      for (LHEvent *hasEncourage in self.encourageList) {
        [pushToUsers addObject:hasEncourage.user];
      }
      
      [pushQuery whereKey:@"user" containsAllObjectsInArray:pushToUsers];
      [pushQuery whereKey:@"user" equalTo:self.story.StoryTeller];
      [pushQuery whereKey:@"user" notEqualTo:[LHUser currentUser]];
      
      PFPush *push = [[PFPush alloc] init];
      [push setQuery:pushQuery];
      
      NSMutableString *message = [[NSMutableString alloc] init];
      [message appendString:[NSString stringWithFormat:@"%@ gave %i stars.", [LHUser currentUser].name, self.encourage.value.intValue]];
      if (self.reviewTextField.text.length > 0) {
        [message appendString:[NSString stringWithFormat:@"Said %@", self.reviewTextField.text]];
      }
      
      NSMutableDictionary *pushInfo = [[NSMutableDictionary alloc] init];
      [pushInfo setObject:@"com.lovingheart.app.PUSH_STORY" forKey:@"action"];
      [pushInfo setObject:@"StroyContentActivity" forKey:@"intent"];
      [pushInfo setObject:message forKey:@"alert"];
      [pushInfo setObject:self.story.objectId forKey:@"objectId"];
      
      [push setData:pushInfo];
      [push sendPushInBackground];
      
      [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserStoryRefreshNotification object:nil];
      }];
    } else {
      [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
  }];
}

- (void)cancelButtonPressed:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)oneStarButtonItemPressed:(id)sender {
  
  [self performSelector:@selector(multiButtonPressed:) withObject:[NSNumber numberWithInt:1]];
  
}

- (void)twoStarButtonItemPressed:(id)sender {
  [self performSelector:@selector(multiButtonPressed:) withObject:[NSNumber numberWithInt:2]];}

- (void)threeStarButtonItemPressed:(id)sender {
  [self performSelector:@selector(multiButtonPressed:) withObject:[NSNumber numberWithInt:3]];
}

- (void)fourStarButtonItemPressed:(id)sender {
  [self performSelector:@selector(multiButtonPressed:) withObject:[NSNumber numberWithInt:4]];
}

- (void)fiveStarButtonItemPressed:(id)sender {
  [self performSelector:@selector(multiButtonPressed:) withObject:[NSNumber numberWithInt:5]];
}

@end

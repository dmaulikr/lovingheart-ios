//
//  LHStoryViewTableViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/21.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoryViewTableViewController.h"
#import "LHUserInfoTableViewCell.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import <AFNetworking/AFNetworking.h>
#import "LHStoryContentTableViewCell.h"
#import "LHLocationAreaTableViewCell.h"
#import "LHStoryImageTableViewCell.h"
#import "LHCategoryLabelCell.h"
#import "LHEvent.h"
#import "LHReviewStarsTableViewCell.h"
#import <BlocksKit/UIActionSheet+BlocksKit.h>
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import "NSString+Extra.h"
#import "LHStoryReviewViewController.h"
#import "LHLoginViewController.h"

@interface LHStoryViewTableViewController ()

@end

@implementation LHStoryViewTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  self.shareButton.target = self;
  self.shareButton.action = @selector(shareButtonClicked:);
  
  __block LHStoryViewTableViewController *__self = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:kUserStoryRefreshNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    [__self loadObjects];
  }];

  [self loadObjects];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)loadObjects {
  __block LHStoryViewTableViewController *__self = self;
  PFQuery *query = [LHStory query];
  [query includeKey:@"StoryTeller"];
  [query includeKey:@"StoryTeller.avatar"];
  [query includeKey:@"graphicPointer"];
  [query includeKey:@"ideaPointer"];
  [query includeKey:@"ideaPointer.categoryPointer"];
  [query getObjectInBackgroundWithId:self.story.objectId block:^(PFObject *object, NSError *error) {
    if (!error) {
      __self.story = (LHStory *)object;
      [__self.tableView reloadData];
    }
  }];
  
  PFQuery *eventQuery = [LHEvent query];
  [eventQuery whereKey:@"story" equalTo:self.story];
  [eventQuery whereKey:@"action" equalTo:@"review_story"];
  [eventQuery includeKey:@"user"];
  [eventQuery includeKey:@"user.avatar"];
  [eventQuery orderByDescending:@"createdAt"];
  [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (objects) {
      __self.events = objects;
      [__self.tableView reloadData];
    }
    
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    int numbersOfRow = 3;
    if (self.story.graphicPointer) {
      numbersOfRow += 1;
    }
    if (self.story.ideaPointer && self.story.ideaPointer.categoryPointer) {
      numbersOfRow += 1;
    }
    return numbersOfRow;
  } else if (section == 1) {
    if (self.events.count > 0) {
      return 1 + self.events.count;
    } else if (self.events.count == 0) {
      return 1 + 1;
    }
  }
  return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return @"Story Impacts";
  }
  return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  
  int numbersOfRow = 3;
  if (indexPath.section == 0 && indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
    LHUserInfoTableViewCell *userInfoCell = (LHUserInfoTableViewCell*)cell;
    
    if ([self.story.status contains:@"anonymous"]) {
      userInfoCell.userNameLabel.text = NSLocalizedString(@"Anonymous", @"Anonymous");
      userInfoCell.userAvatarImageView.image = [UIImage imageNamed:@"ic_action_emo_cool.png"];
      [userInfoCell.userAvatarImageView setNeedsLayout];
    } else {
      userInfoCell.userNameLabel.text = self.story.StoryTeller.name;
      
      if (self.story.StoryTeller.avatar) {
        NSURL* imageUrl = [NSURL URLWithString:self.story.StoryTeller.avatar.imageUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        __block UIImageView *__avatarImageView = userInfoCell.userAvatarImageView;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          __avatarImageView.image = responseObject;
        } failure:nil];
        
        [operation start];
      }
      
    }
    
  } else if (indexPath.section == 0 && indexPath.row == 1) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"StoryContentTableViewCell" forIndexPath:indexPath];
    
    LHStoryContentTableViewCell *storyContentCell = (LHStoryContentTableViewCell *)cell;
    storyContentCell.storyContentLabel.text = self.story.Content;
    storyContentCell.storyContentLabel.numberOfLines = 0;
    [storyContentCell.storyContentLabel sizeToFit];
  } else if (indexPath.section == 0 && indexPath.row == 2) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"LocationAreaTableViewCell" forIndexPath:indexPath];
    
    LHLocationAreaTableViewCell *locationAreaCell = (LHLocationAreaTableViewCell *)cell;
    locationAreaCell.locationLabel.text = self.story.areaName;
    locationAreaCell.dayAgoLabel.text = [self.story.createdAt timeAgo];
  }
  if (self.story.ideaPointer && self.story.ideaPointer.categoryPointer) {
    if (indexPath.section == 0 && indexPath.row == numbersOfRow) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryLabelCell" forIndexPath:indexPath];
      
      LHCategoryLabelCell *categoryCell = (LHCategoryLabelCell *)cell;
      categoryCell.categoryLabel.text = self.story.ideaPointer.categoryPointer.Name;
      categoryCell.ideaLabel.text = self.story.ideaPointer.Name;
    }
    numbersOfRow += 1;
  }
  if (self.story.graphicPointer) {
    if (indexPath.section == 0 && indexPath.row == numbersOfRow) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"StoryImageTableViewCell" forIndexPath:indexPath];
      
      __block LHStoryImageTableViewCell *storyImageCell = (LHStoryImageTableViewCell *)cell;
      storyImageCell.pictureView.image = [UIImage imageNamed:@"card_default"];
      storyImageCell.progressOverlayView.frame = storyImageCell.pictureView.bounds;
      
      PFFile* file = (PFFile*)self.story.graphicPointer.imageFile;
      [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          UIImage *image = [UIImage imageWithData:data];
          storyImageCell.pictureView.image = image;
          [cell setNeedsDisplay];
        }
      } progressBlock:^(int percentDone) {
        float perenctDownFloat = (float)percentDone / 100.f;
        NSLog(@"Download %@ progress: %f", file.url, perenctDownFloat);
        if (perenctDownFloat == 0) {
          [storyImageCell.progressOverlayView displayOperationWillTriggerAnimation];
          storyImageCell.progressOverlayView.hidden = NO;
        }
        if (perenctDownFloat < 1) {
          storyImageCell.progressOverlayView.progress = perenctDownFloat;
        } else {
          [storyImageCell.progressOverlayView displayOperationDidFinishAnimation];
          double delayInSeconds = storyImageCell.progressOverlayView.stateChangeAnimationDuration;
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            storyImageCell.progressOverlayView.progress = 0.;
            storyImageCell.progressOverlayView.hidden = YES;
          });
          
        }
      }];
      numbersOfRow += 1;
    }
  }
  
  // Configure the cell...
  cell.userInteractionEnabled = NO;
  
  if (self.events.count > 0) {
    if (indexPath.section == 1 && indexPath.row == self.events.count) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"actionButtonCell" forIndexPath:indexPath];
      cell.userInteractionEnabled = YES;
    } else if (indexPath.section == 1 && indexPath.row < self.events.count) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewStarsTableViewCell" forIndexPath:indexPath];
      cell.userInteractionEnabled = NO;
      
      LHEvent *currentEvent = [self.events objectAtIndex:indexPath.row];
      
      NSMutableString *starsText = [[NSMutableString alloc] init];
      for (int i= 0; i < currentEvent.value.integerValue; i++) {
        [starsText appendString:@"★"];
      }
      
      LHReviewStarsTableViewCell *reviewStarsCell = (LHReviewStarsTableViewCell *)cell;
      reviewStarsCell.commentLabel.text = currentEvent[@"description"];
      reviewStarsCell.starsLabel.text = starsText;
      reviewStarsCell.dayAgoLabel.text = [currentEvent.createdAt timeAgo];
      reviewStarsCell.userNameLabel.text = currentEvent.user.name;
      
      if (currentEvent.user.avatar) {
        NSURL* imageUrl = [NSURL URLWithString:currentEvent.user.avatar.imageUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        __block UIImageView *__avatarImageView = reviewStarsCell.avatarImageView;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          __avatarImageView.image = responseObject;
        } failure:nil];
        
        [operation start];
      }
      
      
    }
  } else {
    if (indexPath.section == 1 && indexPath.row == 1) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"actionButtonCell" forIndexPath:indexPath];
      cell.userInteractionEnabled = YES;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyEncouragementCell" forIndexPath:indexPath];
      cell.userInteractionEnabled = NO;
    }
  }
  
  
  if (!cell) {
    cell = [[UITableViewCell alloc] init];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 1) {
    LHStoryContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryContentTableViewCell"];
    
    CGFloat labelWidth = cell.storyContentLabel.width;
    CGRect r = [self.story.Content boundingRectWithSize:CGSizeMake(labelWidth, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: cell.storyContentLabel.font}
                                                context:nil];
    return r.size.height + 20.f;
  }
  int numberOfRow = 3;
  if (self.story.ideaPointer && self.story.ideaPointer && self.story.ideaPointer.categoryPointer) {
    if (indexPath.section == 0 && indexPath.row == numberOfRow) {
      return 84.f;
    }
    numberOfRow += 1;
  }
  if (self.story.graphicPointer) {
    if (indexPath.section == 0 && indexPath.row == numberOfRow) {
      return 320;
    }
    numberOfRow += 1;
  }
  if (indexPath.section == 1 && indexPath.row < self.events.count) {
    return 84.f;
  }
  if (self.events.count == 0) {
    if (indexPath.section == 1 && indexPath.row == 0) {
      return 44.f;
    }
  }
  return 44.f;
}

- (void)shareButtonClicked:(id)sender {
  
  __block LHStoryViewTableViewController *__self = self;
  
  UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:NSLocalizedString(@"Actions", nil)];
  __block UIActionSheet *__actionSheet = actionSheet;
  [actionSheet bk_addButtonWithTitle:NSLocalizedString(@"Share to Facebook", nil) handler:^{
    FBRequest *fbRequest = [FBRequest requestForMe];
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:[NSString stringWithFormat:@"http://tw.lovingheartapp.com/story/%@", self.story.objectId]];
    if ([self.story.status isEqualToString:@"anonymous"]) {
      params.name = @"Anonymous";
    } else {
      params.name = self.story.StoryTeller.name;
    }
    if (self.story.ideaPointer) {
      PFObject *idea = [self.story.ideaPointer fetchIfNeeded];
      params.caption = idea[@"Name"];
    } else {
      params.caption = @"This story has inspired me.";
    }
    if ([self.story.graphicPointer.imageType isEqualToString:@"file"]) {
      params.picture = [NSURL URLWithString:self.story.graphicPointer.imageFile.url];
    } else if (self.story.graphicPointer.imageUrl) {
      params.picture = [NSURL URLWithString:self.story.graphicPointer.imageUrl];
    }
    
    params.description = self.story.Content;
    
    // Save sharing
    LHEvent *event = [[LHEvent alloc] init];
    if ([LHUser currentUser]) {
      [event setUser:[LHUser currentUser]];
    }
    event.action = @"share_to_facebook";
    event.story = self.story;
    event.value = [NSNumber numberWithInt:1];
    [event saveInBackground];
    
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
      [FBDialogs presentShareDialogWithLink:params.link name:params.name caption:params.caption description:params.description picture:params.picture clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        if (error) {
          NSLog(@"Error publishing story: %@", error.description);
        } else {
          NSLog(@"result %@", results);
          [SVProgressHUD showSuccessWithStatus:@"Share to Facebook successfully."];
        }
      }];
    } else {
      // Put together the dialog parameters
      NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               params.name, @"name",
                                               params.caption, @"caption",
                                               params.description, @"description",
                                               [params.link absoluteString], @"link",
                                               [params.picture absoluteString], @"picture",
                                               nil];
      
      // Show the feed dialog
      [FBWebDialogs presentFeedDialogModallyWithSession:fbRequest.session
                                             parameters:paramsDictionary
                                                handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                    // An error occurred, we need to handle the error
                                                    // See: https://developers.facebook.com/docs/ios/errors
                                                    NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                    if (result == FBWebDialogResultDialogNotCompleted) {
                                                      // User cancelled.
                                                      NSLog(@"User cancelled.");
                                                    } else {
                                                      // Handle the publish feed callback
                                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                      
                                                      if (![urlParams valueForKey:@"post_id"]) {
                                                        // User cancelled.
                                                        NSLog(@"User cancelled.");
                                                        
                                                      } else {
                                                        // User clicked the Share button
                                                        NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                        NSLog(@"result %@", result);
                                                        [SVProgressHUD showSuccessWithStatus:@"Share to Facebook successfully."];
                                                      }
                                                    }
                                                  }
                                                }];
    }
  }];
  if ([LHUser currentUser] && [self.story.StoryTeller.objectId isEqualToString:[LHUser currentUser].objectId]) {
    [actionSheet bk_setDestructiveButtonWithTitle:NSLocalizedString(@"Delete this story", nil) handler:^{
      
      [UIAlertView bk_showAlertViewWithTitle:@"Delete" message:@"Sure to delete this story?" cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObject:@"Delete"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
          // Remove story
          [SVProgressHUD showWithStatus:@"Deleting"];
          [self.story deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
              [SVProgressHUD showSuccessWithStatus:@"Removed"];
              // Ask to reload
              [[NSNotificationCenter defaultCenter] postNotificationName:kUserStoriesRefreshNotification object:nil];
              [__self.navigationController popViewControllerAnimated:YES];
            } else {
              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
          }];
          
          
        }
        
      }];
      
    }];
  }
  [actionSheet bk_setDestructiveButtonWithTitle:NSLocalizedString(@"Flag inappropriate content", @"Flag inappropriate content") handler:^{
    
    if (![LHUser currentUser]) {
      
      UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:NSLocalizedString(@"Need to login",nil) message:NSLocalizedString(@"Please login before share a story", nil)];
      [alertView bk_addButtonWithTitle:@"Go" handler:^{
        LHLoginViewController *loginViewController =[[LHLoginViewController alloc] init];
          loginViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
          [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
        
      }];
      [alertView bk_setCancelBlock:^{
      }];
      [alertView show];
    } else {
      NSLog(@"Login User Name: %@", [[PFUser currentUser] username]);
      
      [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"Flag inappropriate content", @"Flag inappropriate content") message:NSLocalizedString(@"Report and flag the content", nil) cancelButtonTitle:@"No" otherButtonTitles:[NSArray arrayWithObject:@"YES"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
          LHFlag *flag = [[LHFlag alloc] init];
          flag.User = [LHUser currentUser];
          flag.Status = @"Close";
          flag.Reason = @"Flag and remove inappropriate content";
          flag.object = @"Story";
          flag.ObjID = _story.objectId;
          [SVProgressHUD showWithStatus:@"Flaging..."];
          [flag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
              [SVProgressHUD showSuccessWithStatus:@"Thank you! We will check on that."];
              [[NSNotificationCenter defaultCenter] postNotificationName:kUserStoriesRefreshNotification object:nil];
              [self.navigationController popViewControllerAnimated:YES];
            } else if (error) {
              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
          }];
        }
      }];
    }
    
    
    
    

  }];
  
  [actionSheet bk_setCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil) handler:^{
    [__actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  }];
  [actionSheet showInView:[self.view window]];
  
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
  NSArray *pairs = [query componentsSeparatedByString:@"&"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  for (NSString *pair in pairs) {
    NSArray *kv = [pair componentsSeparatedByString:@"="];
    NSString *val =
    [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    params[kv[0]] = val;
  }
  return params;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"EncourageStory"]) {
    
    if (![PFUser currentUser]) {
      
      UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:NSLocalizedString(@"Need to login",nil) message:NSLocalizedString(@"Please login before share a story", nil)];
      [alertView bk_addButtonWithTitle:@"Go" handler:^{
        [segue.destinationViewController dismissViewControllerAnimated:YES completion:^{
          LHLoginViewController *loginViewController =[[LHLoginViewController alloc] init];
          loginViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
          [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
        }];
        
      }];
      [alertView bk_setCancelBlock:^{
        [segue.destinationViewController dismissModalViewControllerAnimated:YES];
      }];
      [alertView show];
    } else {
      NSLog(@"Login User Name: %@", [[PFUser currentUser] username]);
      
      UINavigationController *storyReviewNavigationController = (UINavigationController *)segue.destinationViewController;
      LHStoryReviewViewController *storyReviewController = [storyReviewNavigationController.viewControllers objectAtIndex:0];
      storyReviewController.story = self.story;
      storyReviewController.encourageList = self.events;
    }
  }
}

@end

//
//  LHCurrentUserTableViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHCurrentUserTableViewController.h"
#import "StoryCell.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import "LHStoryViewTableViewController.h"
#import "LHUserInfoTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <UIAlertView+BlocksKit.h>
#import "LHLoginViewController.h"

@implementation LHCurrentUserTableViewController

- (void)awakeFromNib {
  self.parseClassName = @"Story";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 10;
}

- (void)objectsWillLoad {

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (![LHUser currentUser]) {
    // Ask to login
    
    UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:
                              NSLocalizedString(@"Need to login", nil) message:NSLocalizedString(@"Please login before share a story", nil)];
    [alertView bk_addButtonWithTitle:@"Go" handler:^{
      
      LHLoginViewController *loginViewController =[[LHLoginViewController alloc] init];
      loginViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
      [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
      
    }];
    [alertView bk_setCancelBlock:^{
      
    }];
    [alertView show];
    
  }
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHStory query];
  
  [query includeKey:@"StoryTeller"];
  [query includeKey:@"StoryTeller.avatar"];
  [query includeKey:@"graphicPointer"];
  [query includeKey:@"ideaPointer"];
  [query includeKey:@"ideaPointer.categoryPointer"];
  
  if ([LHUser currentUser]) {
    [query whereKey:@"StoryTeller" equalTo:[LHUser currentUser]];
  } else {
    [query whereKey:@"StoryTeller" equalTo:@""];
  }
  
  [query whereKey:@"language" containedIn:[LHAltas supportLanguageList]];
  [query orderByDescending:@"createdAt"];
  
  // If no objects are loaded in memory, we look to the cache first to fill the table
  // and then subsequently do a query against the network.
  if (self.objects.count == 0) {
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  }
  
  return query;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0 && [LHUser currentUser]) {
    return 1;
  }
  else if (section == 1) {
    return self.objects.count;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  
  if (indexPath.section == 0 && indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
    LHUserInfoTableViewCell *userInfoCell = (LHUserInfoTableViewCell*)cell;
    userInfoCell.userInteractionEnabled = NO;
    
    userInfoCell.userNameLabel.text = [LHUser currentUser].name;
    
    if ([LHUser currentUser].avatar) {
      LHGraphicImage *avatar = (LHGraphicImage *)[[LHUser currentUser].avatar fetchIfNeeded];
      NSURL* imageUrl = [NSURL URLWithString:avatar.imageUrl];
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
  
  if (indexPath.section == 1) {
    
    LHStory *storyObject = (LHStory *)[self.objects objectAtIndex:indexPath.row];
    if (storyObject.graphicPointer) {
      
      cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileStoryImageCell"];
      StoryCell *storyCell = (StoryCell *)cell;
      storyCell.nameLabel.text = storyObject.StoryTeller.name;
      storyCell.contentLabel.text = storyObject.Content;
      
      storyCell.pictureView.image = [UIImage imageNamed:@"card_default"];
      storyCell.progressOverlayView.frame = storyCell.pictureView.bounds;
      
      PFFile* file = (PFFile*)storyObject.graphicPointer.imageFile;
      [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          UIImage *image = [UIImage imageWithData:data];
          StoryCell* cell = (StoryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
          
          cell.pictureView.image = image;
          [cell setNeedsDisplay];
        }
      } progressBlock:^(int percentDone) {
        float perenctDownFloat = (float)percentDone / 100.f;
        NSLog(@"Download %@ progress: %f", file.url, perenctDownFloat);
        if (perenctDownFloat == 0) {
          [storyCell.progressOverlayView displayOperationWillTriggerAnimation];
          storyCell.progressOverlayView.hidden = NO;
        }
        if (perenctDownFloat < 1) {
          storyCell.progressOverlayView.progress = perenctDownFloat;
        } else {
          [storyCell.progressOverlayView displayOperationDidFinishAnimation];
          double delayInSeconds = storyCell.progressOverlayView.stateChangeAnimationDuration;
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            storyCell.progressOverlayView.progress = 0.;
            storyCell.progressOverlayView.hidden = YES;
          });
          
        }
      }];
      storyCell.locationLabel.text = storyObject.areaName;
      storyCell.timeLabel.text = [storyObject.createdAt timeAgo];
    } else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileStoryCell"];
      StoryCell *storyCell = (StoryCell *)cell;
      storyCell.nameLabel.text = storyObject.StoryTeller.name;
      storyCell.contentLabel.text = storyObject.Content;
      storyCell.contentLabel.numberOfLines = 1;
      storyCell.locationLabel.text = storyObject.areaName;
      storyCell.timeLabel.text = [storyObject.createdAt timeAgo];
    }
    
    
  }
  
  if (!cell) {
    cell = [[UITableViewCell alloc] init];
  }
  
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return nil;
  } else if (section == 1) {
    return NSLocalizedString(@"Stories", @"Stories");
  }
  return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    return 100.f;
  }
  return 44.f;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
  PFTableViewCell *cell  = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"loadCell"];
  UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithFrame:cell.bounds];
  spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  [spinner startAnimating];
  [cell addSubview:spinner];
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath.row %i" , indexPath.row);
  if (indexPath.section == 1 && indexPath.row >= self.objects.count -1) {
    [self loadNextPage];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"pushToStory"]) {
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    LHStory *story = (LHStory *)[self objectAtIndexPath:selectedPath];
    
    LHStoryViewTableViewController *storyViewController = (LHStoryViewTableViewController *)segue.destinationViewController;
    [storyViewController setStory:story];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGRect frame = self.navigationController.navigationBar.frame;
  CGFloat size = frame.size.height - 21;
  CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
  CGFloat scrollOffset = scrollView.contentOffset.y;
  CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
  CGFloat scrollHeight = scrollView.frame.size.height;
  CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
  
  if (scrollOffset <= -scrollView.contentInset.top) {
    frame.origin.y = 20;
  } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
    frame.origin.y = -size;
    
  } else {
    frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
  }
  
  [self.navigationController.navigationBar setFrame:frame];
  [self updateBarButtonItems:(1 - framePercentageHidden)];
  self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [self stoppedScrolling];
  }
}

- (void)stoppedScrolling {
  CGRect frame = self.navigationController.navigationBar.frame;
  if (frame.origin.y < 20) {
    [self animateNavBarTo:-(frame.size.height - 21)];
  }
}

- (void)updateBarButtonItems:(CGFloat)alpha {
  [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
    item.customView.alpha = alpha;
  }];
  [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
    item.customView.alpha = alpha;
  }];
  self.navigationItem.titleView.alpha = alpha;
  [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [[UIColor whiteColor] colorWithAlphaComponent:alpha],
                                                                   NSForegroundColorAttributeName,
                                                                   nil]];
  
  self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y {
  [UIView animateWithDuration:0.2 animations:^{
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
    frame.origin.y = y;
    [self.navigationController.navigationBar setFrame:frame];
    [self updateBarButtonItems:alpha];
  }];
}


@end

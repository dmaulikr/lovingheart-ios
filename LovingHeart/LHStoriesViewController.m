//
//  StoryTimelineViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoriesViewController.h"
#import "StoryCell.h"
#import <AFNetworking/AFNetworking.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import "LHStoryViewController.h"
#import <UIAlertView+BlocksKit.h>
#import "LHLoginViewController.h"
#import "DAProgressOverlayView.h"
#import "LHStoryPickViewController.h"

@interface LHStoriesViewController ()

@end

@implementation LHStoriesViewController

- (void)awakeFromNib {
  self.parseClassName = @"Story";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 10;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(LHStory *)object {
  
  StoryCell *cell;
  if (object[@"graphicPointer"]) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"storyImageCell"];
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell"];
  }
  cell.avatarView.image = [UIImage imageNamed:@"defaultAvatar"];
  [cell.avatarView setBackgroundColor:kColorLovingHeartRed];
  switch (self.storiesType) {
    case kStories_Anonymous:
      cell.nameLabel.text = NSLocalizedString(@"Anonymous", @"Anonymous");
      cell.avatarView.image = [UIImage imageNamed:@"ic_action_emo_cool.png"];
      break;
    default:
      cell.nameLabel.text = object.StoryTeller.name;
      if (object.StoryTeller.avatar) {
        NSURL* imageUrl = [NSURL URLWithString:object.StoryTeller.avatar.imageUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        }];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          StoryCell* cell = (StoryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
          cell.avatarView.image = responseObject;
        } failure:nil];
        
        [operation start];
      }
      break;
  }
  
  cell.contentLabel.text = object.Content;
  
  if (object.graphicPointer) {
    cell.pictureView.image = [UIImage imageNamed:@"card_default"];
    cell.progressOverlayView.frame = cell.pictureView.bounds;
    
    PFFile* file = (PFFile*)object.graphicPointer.imageFile;
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
        [cell.progressOverlayView displayOperationWillTriggerAnimation];
        cell.progressOverlayView.hidden = NO;
      }
      if (perenctDownFloat < 1) {
        cell.progressOverlayView.progress = perenctDownFloat;
      } else {
        [cell.progressOverlayView displayOperationDidFinishAnimation];
        double delayInSeconds = cell.progressOverlayView.stateChangeAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          cell.progressOverlayView.progress = 0.;
          cell.progressOverlayView.hidden = YES;
        });
        
      }
    }];
  }
  
  cell.locationLabel.text = object.areaName;
  cell.timeLabel.text = [object.createdAt timeAgo];
  
  return cell;
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
  if (indexPath.row == self.objects.count) {
    [self loadNextPage];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == self.objects.count) return 44;
  else {
    StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyImageCell"];
    PFObject* object = self.objects[indexPath.row];
    CGFloat labelWidth = 294;
    CGRect r = [object[@"Content"] boundingRectWithSize:CGSizeMake(labelWidth, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: cell.contentLabel.font}
                                                context:nil];
    
    if (object[@"graphicPointer"]) {
      return CGRectGetHeight(r) + 420;
    } else {
      return CGRectGetHeight(r) + 110;
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 150.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"pushStoryContent"] || [segue.identifier isEqual:@"pushStoryImageContent"]) {
    LHStoryViewController *storyViewController = segue.destinationViewController;
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    LHStory *story = (LHStory *)[self objectAtIndexPath:selectedPath];
    [storyViewController setStory:story];
  }
  
  if ([segue.identifier isEqual:@"presentPostViewController"]) {
    
    if (![PFUser currentUser]) {
      
      UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"Need to login" message:@"Please login before share a story"];
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
    }
    
  }
  

  
}

@end

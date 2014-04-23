//
//  StoryTimelineViewController.m
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoriesViewController.h"
#import <BlocksKit/BlocksKit.h>
#import <UIBarButtonItem+BlocksKit.h>
#import "StoryCell.h"
#import <AFNetworking/AFNetworking.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import "LHStoryViewTableViewController.h"
#import <UIAlertView+BlocksKit.h>
#import "LHLoginViewController.h"
#import "DAProgressOverlayView.h"

@interface LHStoriesViewController ()

@end

@implementation LHStoriesViewController

- (void)awakeFromNib {
  self.parseClassName = @"Story";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 10;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = NSLocalizedString(@"Latest Stories", @"Latest Stories");
  
  [_storiesTypeSegmentedControl addTarget:self action:@selector(storiesSegmented:) forControlEvents:UIControlEventValueChanged];
  
  __block LHStoriesViewController *__self = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:kUserStoriesRefreshNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    [__self loadObjects];
  }];
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHStory query];
  
  [query includeKey:@"StoryTeller"];
  [query includeKey:@"StoryTeller.avatar"];
  [query includeKey:@"graphicPointer"];
  [query includeKey:@"ideaPointer"];
  [query includeKey:@"ideaPointer.categoryPointer"];
  
  [query whereKey:@"language" containedIn:[LHAltas supportLanguageList]];
  
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
  if (object.areaName) {
    cell.locationLabel.text = object.areaName;
  } else {
    cell.locationLabel.text = @"Some where";
  }
  
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
      return CGRectGetHeight(r) + 405;
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
    LHStoryViewTableViewController *storyViewController = segue.destinationViewController;
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    LHStory *story = (LHStory *)[self objectAtIndexPath:selectedPath];
    [storyViewController setStory:story];
  }
  
  if ([segue.identifier isEqual:@"presentPostViewController"]) {
    
    if (![PFUser currentUser]) {
      
      UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:NSLocalizedString(@"Need to login", nil) message:NSLocalizedString(@"Please login before share a story",nil)];
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

//
//  LHStoriesFromCardViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/2.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoriesFromCardViewController.h"
#import "StoryCell.h"
#import "LHStoriesViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import "StoryCell.h"
#import "LHStoryViewTableViewController.h"

@implementation LHStoriesFromCardViewController

- (void)awakeFromNib {
  self.parseClassName = @"Story";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 10;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = self.ideaObject.Name;
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHStory query];
  
  [query includeKey:@"graphicPointer"];
  [query includeKey:@"ideaPointer"];
  [query includeKey:@"ideaPointer.categoryPointer"];
  [query includeKey:@"StoryTeller"];
  [query includeKey:@"StoryTeller.avatar"];
  [query whereKey:@"status" notEqualTo:@"close"];
  
  if (self.ideaObject) {
    [query whereKey:@"ideaPointer" equalTo:self.ideaObject];
  }
  
  // If no objects are loaded in memory, we look to the cache first to fill the table
  // and then subsequently do a query against the network.
  if (self.objects.count == 0) {
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  }
  
  [query orderByDescending:@"createdAt"];
  
  return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(LHStory *)storyObject {
  
  StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyImageCell"];

  StoriesType storyType = kStories_Latest;
  if ([storyObject.status isEqualToString:@"anonymous"]) {
    storyType = kStories_Anonymous;
  }
  
  switch (storyType) {
    case kStories_Anonymous:
      cell.nameLabel.text = NSLocalizedString(@"Anonymous", @"Anonymous");
      break;
    default:
      cell.nameLabel.text = storyObject.StoryTeller.name;
      break;
  }
  
  cell.contentLabel.text = storyObject.Content;
  
  if (storyObject.graphicPointer) {
    cell.pictureView.image = [UIImage imageNamed:@"card_default"];
    cell.progressOverlayView.frame = cell.pictureView.bounds;
    
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
  } else {
  }
  
  if  (storyObject.areaName) {
    cell.locationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"From location", @"From"), storyObject.areaName];
  } else {
    cell.locationLabel.text = NSLocalizedString(@"Some where", @"Some where");
  }
  
  cell.timeLabel.text = [storyObject.createdAt timeAgo];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyImageCell"];
  
  if (indexPath.row < self.objects.count) {
    LHStory *currentStory = [self.objects objectAtIndex:indexPath.row];
    CGRect r = [currentStory.Content boundingRectWithSize:CGSizeMake(cell.contentLabel.width, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: cell.contentLabel.font}
                                                  context:nil];
    return r.size.height + 120.f;
  }
  return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 100.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"pushToStory"]) {
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    LHStory *story = (LHStory *)[self objectAtIndexPath:selectedPath];
    
    LHStoryViewTableViewController *storyViewController = (LHStoryViewTableViewController *)segue.destinationViewController;
    [storyViewController setStory:story];
  }
}

@end

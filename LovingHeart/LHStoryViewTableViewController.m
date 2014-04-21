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

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
    return 1 + self.events.count;
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
  
  if (!cell) {
    cell = [[UITableViewCell alloc] init];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 1) {
    LHStoryContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryContentTableViewCell"];

    CGFloat labelWidth = 320;
    CGRect r = [self.story.Content boundingRectWithSize:CGSizeMake(labelWidth, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: cell.storyContentLabel.font}
                                                context:nil];
    return r.size.height + 20.f;
  }
  int numberOfRow = 3;
  if (self.story.ideaPointer && self.story.ideaPointer.categoryPointer) {
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
  return 44.f;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

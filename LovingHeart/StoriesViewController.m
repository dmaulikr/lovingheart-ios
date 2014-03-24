//
//  StoryTimelineViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "StoriesViewController.h"
#import "StoryCell.h"
#import <AFNetworking/AFNetworking.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@interface StoriesViewController ()

@end

@implementation StoriesViewController

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

- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
  
  [query includeKey:@"StoryTeller"];
  [query includeKey:@"StoryTeller.avatar"];
  [query includeKey:@"graphicPointer"];
  
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
                        object:(PFObject *)object
{
  StoryCell *cell;
  if (object[@"graphicPointer"]) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"storyImageCell"];
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell"];
  }
  
  cell.nameLabel.text = object[@"StoryTeller"][@"name"];
  cell.contentLabel.text = object[@"Content"];
  cell.avatarView.image = [UIImage imageNamed:@"defaultAvatar"];
  
  if (object[@"StoryTeller"][@"avatar"]) {
    NSURL* imageUrl = [NSURL URLWithString:object[@"StoryTeller"][@"avatar"][@"imageUrl"]];
    NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      StoryCell* cell = (StoryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
      
      cell.avatarView.image = responseObject;
    } failure:nil];
    
    [operation start];
  }
  
  if (object[@"graphicPointer"]) {
    cell.pictureView.image = nil;
    PFFile* file = (PFFile*) object[@"graphicPointer"][@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        StoryCell* cell = (StoryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.pictureView.image = image;
        [cell setNeedsDisplay];
      }
    }];
  }
  
  cell.locationLabel.text = object[@"areaName"];
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
      return CGRectGetHeight(r) + 450;
    } else {
      return CGRectGetHeight(r) + 110;
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 150.0f;
}


@end

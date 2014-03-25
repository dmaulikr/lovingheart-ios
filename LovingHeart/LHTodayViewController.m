//
//  LHTodayViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/25.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHTodayViewController.h"

@implementation LHTodayViewController

- (void)awakeFromNib {
  self.parseClassName = @"Today";
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
                        object:(PFObject *)object {
  
  return nil;
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
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 150.0f;
}

@end

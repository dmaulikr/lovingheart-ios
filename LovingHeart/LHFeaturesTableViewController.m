//
//  LHFeaturesTableViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHFeaturesTableViewController.h"
#import "LHParseObject.h"
#import "LHIdeaViewCell.h"
#import "LHIdeaCardViewController.h"

@interface LHFeaturesTableViewController ()

@end

@implementation LHFeaturesTableViewController

- (void)awakeFromNib {
  self.parseClassName = @"Today";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 5;
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHToday query];
  
  [query includeKey:@"ideaPointer"];
  [query includeKey:@"ideaPointer.graphicPointer"];
  [query includeKey:@"ideaPointer.categoryPointer"];
  [query whereKey:@"status" equalTo:@"open"];
  
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
                        object:(LHToday *)todayObject {
  
  LHIdeaViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ideaCardViewCell"];
  
  if (todayObject.ideaPointer.graphicPointer) {
    cell.ideaImageView.image = [UIImage imageNamed:@"card_default"];
    PFFile* file = (PFFile*)todayObject.ideaPointer.graphicPointer.imageFile;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        LHIdeaViewCell* cell = (LHIdeaViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.ideaImageView.image = image;
        [cell setNeedsDisplay];
      }
    }];
  }
  
  [cell.ideaTitleLabel setText:todayObject.ideaPointer.Name];
  [cell.ideaCardTitleLabel setText:NSLocalizedString(todayObject.type, @"Feature")
   ];
  [cell.ideaContentLabel setText:todayObject.ideaPointer.Description];
  [cell.ideaContentLabel setNumberOfLines:0];
  [cell.ideaContentLabel sizeToFit];
  [cell.categoryTitleLabel setText:todayObject.ideaPointer.categoryPointer.Name];
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
  return 540.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 540.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  if ([segue.identifier isEqual:@"pushIdeaCardViewController"]) {
    LHIdeaCardViewController *viewController = segue.destinationViewController;
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    LHToday *today = (LHToday *)[self objectAtIndexPath:selectedPath];
    [viewController setIdea:today.ideaPointer];
  }
  
}

@end

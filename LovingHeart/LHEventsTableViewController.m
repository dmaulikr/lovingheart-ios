//
//  LHEventsTableViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHEventsTableViewController.h"
#import "LHUserInfoTableViewCell.h"
#import "NIWebController.h"
#import <AFNetworking/AFNetworking.h>
#import "LHIdeaGroupCell.h"
#import "LHIdeaGroup.h"
#import "LHIdeaGroupListViewController.h"

@interface LHEventsTableViewController ()

@end

@implementation LHEventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
  self.parseClassName = @"IdeaGroup";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 10;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.title = self.organizer.name;
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHIdeaGroup query];
  
  [query whereKey:@"Organizer" equalTo:self.organizer];
  [query whereKey:@"status" notEqualTo:@"close"];
  
  // If no objects are loaded in memory, we look to the cache first to fill the table
  // and then subsequently do a query against the network.
  if (self.objects.count == 0) {
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  }
  
  [query orderByDescending:@"Sequence"];
  
  return query;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(LHIdeaGroup *)ideaGroupObject
{
  UITableViewCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"IdeaGroupCell" forIndexPath:indexPath];
    
    LHIdeaGroupCell *ideaGroupCell = (LHIdeaGroupCell *)cell;
    
    ideaGroupCell.titleLabel.text = ideaGroupObject.name;
    ideaGroupCell.descriptionLabel.text = ideaGroupObject.Description;
  
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

    LHIdeaGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdeaGroupCell"];
    
    CGFloat labelWidth = cell.descriptionLabel.width;
    LHIdeaGroup *currentGroup = [self.objects objectAtIndex:indexPath.row];
    CGRect r = [currentGroup.Description boundingRectWithSize:CGSizeMake(labelWidth, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: cell.descriptionLabel.font}
                                                context:nil];
    return r.size.height + 60.f;


}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
  if  ([segue.identifier isEqualToString:@"OpenPartnerInfo"]) {
    NIWebController *webController = segue.destinationViewController;
    webController.edgesForExtendedLayout = UIRectEdgeNone;
    [webController openURL:[NSURL URLWithString:self.organizer.webUrl]];
  }
  
  if ([segue.identifier isEqualToString:@"PushToIdeaCall"]) {
    LHIdeaGroupListViewController *ideaGroupViewController = (LHIdeaGroupListViewController*)segue.destinationViewController;
    ideaGroupViewController.ideaGroup = [self.objects objectAtIndex:[self.tableView indexPathForSelectedRow].row];
  }
}


@end

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

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  _ideaGroups = [[NSMutableArray alloc] init];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  if (self.organizer) {
    self.title = self.organizer.name;
    
    __block LHEventsTableViewController *__self = self;
    PFQuery *ideaGroupQuery = [LHIdeaGroup query];
    [ideaGroupQuery whereKey:@"Organizer" equalTo:self.organizer];
    [ideaGroupQuery whereKey:@"status" notEqualTo:@"close"];
    [ideaGroupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      [__self.ideaGroups removeAllObjects];
      [__self.ideaGroups addObjectsFromArray:objects];
      
      [__self.tableView reloadData];
    }];
  }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return 1;
  }
  if  (section == 1) {
    return self.ideaGroups.count;
  }
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  
  if (indexPath.section == 0 && indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
    
    LHUserInfoTableViewCell *infoCell = (LHUserInfoTableViewCell *)cell;
    
    infoCell.userNameLabel.text = self.organizer.name;
    
    if (self.organizer.graphicPointer) {
      NSURL* imageUrl;
      
      if (self.organizer.graphicPointer.imageUrl) {
        imageUrl = [NSURL URLWithString:self.organizer.graphicPointer.imageUrl];
      }
      if (self.organizer.graphicPointer.imageFile) {
        imageUrl = [NSURL URLWithString:self.organizer.graphicPointer.imageFile.url];
      }
      NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
      AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
      operation.responseSerializer = [AFImageResponseSerializer serializer];
      
      __block UIImageView *__avatarImageView = infoCell.userAvatarImageView;
      [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __avatarImageView.image = responseObject;
      } failure:nil];
      
      [operation start];
    }
    
  }
  if (indexPath.section == 1) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"IdeaGroupCell" forIndexPath:indexPath];
    
    LHIdeaGroupCell *ideaGroupCell = (LHIdeaGroupCell *)cell;
    LHIdeaGroup *currentGroup = [self.ideaGroups objectAtIndex:indexPath.row];
    
    ideaGroupCell.titleLabel.text = currentGroup.name;
    ideaGroupCell.descriptionLabel.text = currentGroup.Description;
  }
  
  if (!cell) {
    cell = [[UITableViewCell alloc] init];
  }
  
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    LHIdeaGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdeaGroupCell"];
    
    CGFloat labelWidth = 320;
    LHIdeaGroup *currentGroup = [self.ideaGroups objectAtIndex:indexPath.row];
    CGRect r = [currentGroup.Description boundingRectWithSize:CGSizeMake(labelWidth, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: cell.descriptionLabel.font}
                                                context:nil];
    return r.size.height + 50.f;

  }
  return 44.f;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"pushWebController"]) {
    
    NIWebController *webController = segue.destinationViewController;
    webController.edgesForExtendedLayout = UIRectEdgeNone;
    
    [webController openURL:[NSURL URLWithString:self.organizer.webUrl]];
    
  }
  
  if ([segue.identifier isEqualToString:@"PushToIdeaCall"]) {
    LHIdeaGroupListViewController *ideaGroupViewController = (LHIdeaGroupListViewController*)segue.destinationViewController;
    ideaGroupViewController.ideaGroup = [self.ideaGroups objectAtIndex:[self.tableView indexPathForSelectedRow].row];
  }
}


@end

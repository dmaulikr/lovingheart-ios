//
//  LHUserTableViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/15.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHUserTableViewController.h"
#import "LHUserInfoTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "LHUserStateTableViewCell.h"

@interface LHUserTableViewController ()

@end

@implementation LHUserTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)awakeFromNib {
  self.title = NSLocalizedString(@"User Profile", @"User Profile");
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidLoad {
  [super viewDidLoad];
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
    return 2;
  }
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *header = @"";
  switch (section) {
    case 0:
      
      break;
    case 1:
      header = @"Report";
      break;
    default:
      break;
  }
  return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
      LHUserInfoTableViewCell *userInfoCell = (LHUserInfoTableViewCell *)cell;
      userInfoCell.userNameLabel.text = self.user.name;
      
      if (self.user.avatar && self.user.avatar.imageUrl) {
        NSURL* imageUrl = [NSURL URLWithString:self.user.avatar.imageUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        __block UIImageView *__avatarImageView = userInfoCell.userAvatarImageView;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          __avatarImageView.image = responseObject;
        } failure:nil];
        
        [operation start];
      }
      
    } else if (indexPath.row == 1) {
      if (self.userImpact) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserStateTableViewCell" forIndexPath:indexPath];
        LHUserStateTableViewCell *userStateCell = (LHUserStateTableViewCell *)cell;
        userStateCell.numberOfPostsLabel.text = [NSString stringWithFormat:@"%i\nposts", self.userImpact.sharedStoriesCount.intValue];
        [userStateCell.numberOfPostsLabel sizeToFit];
        userStateCell.numberOfGraphicsLabel.text = [NSString stringWithFormat:@"%i\nposts", self.userImpact.graphicsEarnedCount.intValue];
         [userStateCell.numberOfGraphicsLabel sizeToFit];
        userStateCell.numberOfEnergyLabel.text = [NSString stringWithFormat:@"%i\nposts", self.userImpact.reviewStarsImpact.intValue];
         [userStateCell.numberOfEnergyLabel sizeToFit];
      }
    }
  }
  
  if (!cell) {
    cell = [[UITableViewCell alloc] init];
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return 44;
    } else if (indexPath.row == 1) {
      return 100;
    }
  }
  return 48;
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

- (void)refresh:(id)sender {
  [self queryUserInfo];
}

- (void)queryUserInfo {
  // Query current User
  if (self.user) {
    
    if (![self.refreshControl isRefreshing]) {
      [self.refreshControl beginRefreshing];
    }

    PFQuery *currentUserQuery = [LHUser query];
    [currentUserQuery includeKey:@"avatar"];
    [currentUserQuery whereKey:@"objectId" equalTo:self.user.objectId];
    currentUserQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    currentUserQuery.maxCacheAge = 100 * 10;
    [currentUserQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (!error) {
        LHUser *userObject = (LHUser *)object;
        
        _user = userObject;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      
    }];
    
    PFQuery *userImpactQuery = [LHUserImpact query];
    [userImpactQuery whereKey:@"User" equalTo:self.user];
    userImpactQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    userImpactQuery.maxCacheAge = 100 * 10;
    [userImpactQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (!error) {
        self.userImpact = (LHUserImpact *)object;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
      }
    }];

  }
}

@end

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
  } else if (section == 1) {
    return 0;
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
  }
  // Configure the cell...
  cell.userInteractionEnabled = NO;
  
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
    return r.size.height + 40.f;
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

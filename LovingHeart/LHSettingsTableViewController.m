//
//  LHSettingsTableViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHSettingsTableViewController.h"
#import <NIWebController.h>
#import "LHLoginViewController.h"

@interface LHSettingsTableViewController ()

@end

@implementation LHSettingsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self.doneButtonItem setTarget:self];
  [self.doneButtonItem setAction:@selector(donePress:)];
}

- (void)donePress:(id)selector {
  [self.navigationController dismissViewControllerAnimated:YES completion:^{
    // Complete dismiss
  }];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (section == 0) {
    return 1;
  }
  if (section == 1) {
    return 4;
  }
  return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Account";
  }
  else if (section == 1) {
    return @"About";
  }
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell;
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"settingsPlain" forIndexPath:indexPath];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsInfo"];
      }
      [cell.textLabel setText:@"Login"];
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"settingsInfo" forIndexPath:indexPath];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsInfo"];
      }
      [cell.textLabel setText:@"Version"];
      [cell.detailTextLabel setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    }
    if (indexPath.row == 1) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"settingsWebInfo" forIndexPath:indexPath];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsWebInfo"];
      }
      [cell.textLabel setText:@"Acknowledgement"];
      [cell.detailTextLabel setText:@"Thanks to the communitites for helping us."];
    }
    if (indexPath.row == 2) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"settingsWebInfo" forIndexPath:indexPath];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsWebInfo"];
      }
      [cell.textLabel setText:@"Terms of Use"];
      [cell.detailTextLabel setText:@"Read the terms of use."];
    }
    if (indexPath.row == 3) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"settingsWebInfo" forIndexPath:indexPath];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsWebInfo"];
      }
      [cell.textLabel setText:@"Pricacy Policy"];
      [cell.detailTextLabel setText:@"Read the privacy policy."];
    }
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 0) {
    LHLoginViewController *loginViewController = [[LHLoginViewController alloc] init];
    loginViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
    [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
  }
}

static NSString *kWebAcknowledgementUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/333115-acknowledgement";
static NSString *kWebTermsOfUseUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/334311-terms-and-conditions-of-use";
static NSString *kPrivacyPolicyUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/333113-privacy-policy";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"pushWebController"]) {
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    if (selectedPath.section == 1 && selectedPath.row == 1) {
      NIWebController *webController = segue.destinationViewController;
      [webController openURL:[NSURL URLWithString:kWebAcknowledgementUrl]];
    }
    if (selectedPath.section == 1 && selectedPath.row == 2) {
      NIWebController *webController = segue.destinationViewController;
      [webController openURL:[NSURL URLWithString:kWebTermsOfUseUrl]];
    }
    if (selectedPath.section == 1 && selectedPath.row == 3) {
      NIWebController *webController = segue.destinationViewController;
      [webController openURL:[NSURL URLWithString:kPrivacyPolicyUrl]];
    }
  }
}

@end

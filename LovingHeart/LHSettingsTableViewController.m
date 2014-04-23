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
#import "LHSignUpViewController.h"
#import <SVProgressHUD.h>
#import "LHSettingsSwitcherTableViewCell.h"
#import <UserVoice.h>
#import <BlocksKit+UIKit.h>

@interface LHSettingsTableViewController ()

@end

@implementation LHSettingsTableViewController

static const int kIndextOfSectionAbout = 3;

static NSString *kWebAcknowledgementUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/333115-acknowledgement#anchor";
static NSString *kWebTermsOfUseUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/334311-terms-and-conditions-of-use#anchor";
static NSString *kPrivacyPolicyUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/333113-privacy-policy#anchor";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self.doneButtonItem setTarget:self];
  [self.doneButtonItem setAction:@selector(donePress:)];
  
  __block LHSettingsTableViewController *__self = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:kUserProfileRefreshNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    [__self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  }];
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
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  switch (section) {
    case 0:
      return 1;
      break;
    case 1:
      return 2;
    case 2:
      return 1;
    case kIndextOfSectionAbout:
      return 4;
    default:
      return 0;
      break;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *title;
  switch (section) {
    case 0:
      title = @"Account";
      break;
    case 1:
      title = @"Support Language";
      break;
    case 2:
      title = @"Feedback";
      break;
    case 3:
      title = @"About";
      break;
    default:
      break;
  }
  return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell;
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"settingsPlain" forIndexPath:indexPath];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsInfo"];
      }
      if ([PFUser currentUser]) {
        [cell.textLabel setText:[NSString stringWithFormat:@"Logout: %@", [PFUser currentUser].email]];
      } else {
        [cell.textLabel setText:NSLocalizedString(@"Login", @"Login")];
      }
    }
  }
  else if (indexPath.section == 1) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"settingsSwitcher" forIndexPath:indexPath];
    if (cell == nil) {
      cell = [[LHSettingsSwitcherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingsSwitcher"];
    }
    LHSettingsSwitcherTableViewCell *switcherCell = (LHSettingsSwitcherTableViewCell*)cell;

    NSString *userLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (indexPath.row == 0) {
      [switcherCell.titleLabel setText:@"English"];
      
      BOOL isSupportEnglish = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultSupportEnglish];

      if (([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSupportEnglish] == nil &&[userLanguage hasPrefix:@"en"])
          || isSupportEnglish) {
        [switcherCell.switcher setOn:YES animated:YES];
      } else {
        [switcherCell.switcher setOn:NO animated:YES];
      }
      
      [switcherCell.switcher bk_addEventHandler:^(id sender) {
        UISwitch *switcher = (UISwitch *)sender;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:switcher.on forKey:kUserDefaultSupportEnglish];
        [userDefaults synchronize];
        
      } forControlEvents:UIControlEventValueChanged];
    }
    else if (indexPath.row == 1) {
      
      [switcherCell.titleLabel setText:@"中文"];
      
      BOOL isSupportChinese = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultSupportChinese];
      
      if (([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSupportChinese] == nil &&[userLanguage hasPrefix:@"zh"])
          || isSupportChinese) {
        [switcherCell.switcher setOn:YES animated:YES];
      } else {
        [switcherCell.switcher setOn:NO animated:YES];
      }
      
      [switcherCell.switcher bk_addEventHandler:^(id sender) {
        UISwitch *switcher = (UISwitch *)sender;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:switcher.on forKey:kUserDefaultSupportChinese];
        [userDefaults synchronize];
        
      } forControlEvents:UIControlEventValueChanged];
    }
  }
  else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"settingsPlain" forIndexPath:indexPath];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsPlain"];
      }
      [cell.textLabel setText:NSLocalizedString(@"Support Center", @"Support Center")];
    }
  }
  else if (indexPath.section == kIndextOfSectionAbout) {
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
    if ([PFUser currentUser] == nil) {
      LHLoginViewController *loginViewController = [[LHLoginViewController alloc] init];
      loginViewController.signUpController = [[LHSignUpViewController alloc] init];
      loginViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
      [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
    } else {
      [PFUser logOut];
      [self.tableView reloadData];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileRefreshNotification object:nil];
    }
    
  }
  else if (indexPath.section == 2 && indexPath.row == 0) {
    // Call this wherever you want to launch UserVoice
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"pushWebController"]) {
    
    NIWebController *webController = segue.destinationViewController;
    webController.edgesForExtendedLayout = UIRectEdgeNone;

    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    if (selectedPath.section == kIndextOfSectionAbout && selectedPath.row == 1) {
      [webController openURL:[NSURL URLWithString:kWebAcknowledgementUrl]];
    }
    if (selectedPath.section == kIndextOfSectionAbout && selectedPath.row == 2) {
      [webController openURL:[NSURL URLWithString:kWebTermsOfUseUrl]];
    }
    if (selectedPath.section == kIndextOfSectionAbout && selectedPath.row == 3) {
      [webController openURL:[NSURL URLWithString:kPrivacyPolicyUrl]];
    }
  }
}

@end

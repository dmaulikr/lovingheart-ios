//
//  LHStoryPickViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/31.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoryPickViewController.h"
#import "LHPickerTableViewCell.h"

@interface LHStoryPickViewController () {
  StoryPickDidSelectRowAtIndexPath _storyPickDidSelect;
}

@end

@implementation LHStoryPickViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [self.cancelButtonItem setTarget:self];
  [self.cancelButtonItem setAction:@selector(cancel:)];
}

- (void)cancel:(id)select {
  [self dismissViewControllerAnimated:YES completion:^{
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHPickerTableViewCell *cell = (LHPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LHPickerTableViewCell" forIndexPath:indexPath];
  
  if ([_selected containsIndex:indexPath.row]) {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else {
    [cell setAccessoryType:UITableViewCellAccessoryNone];
  }
  
    // Configure the cell...
  switch (indexPath.row) {
    case 0:
      [cell.titleLabel setText:@"Latest Stories"];
      break;
    case 1:
      [cell.titleLabel setText:@"Popular Stories"];
      break;
    case 2:
      [cell.titleLabel setText:@"Anonymous Stories"];
      break;
    default:
      break;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self dismissViewControllerAnimated:YES completion:^{
    if (_storyPickDidSelect) {
      _storyPickDidSelect(indexPath);
    }
    
  }];
}

- (void)setDidSelectedRowAtIndexPath:(StoryPickDidSelectRowAtIndexPath)didSelectRowAtIndexPath {
  _storyPickDidSelect = didSelectRowAtIndexPath;
}

@end

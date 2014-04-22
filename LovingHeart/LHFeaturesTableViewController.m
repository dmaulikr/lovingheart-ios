//
//  LHFeaturesTableViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHFeaturesTableViewController.h"
#import "LHParseObject.h"
#import "LHIdeaFeatureViewCell.h"
#import "LHIdeaCardViewController.h"
#import <UIAlertView+BlocksKit.h>
#import "LHLoginViewController.h"
#import "DAProgressOverlayView.h"
#import "LHQbonViewController.h"

@interface LHFeaturesTableViewController ()

@end

@implementation LHFeaturesTableViewController

- (void)awakeFromNib {
  self.parseClassName = @"Today";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 5;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.qbon = [[Qbon alloc] initWithFrame:self.view.frame];
  [self.view addSubview:self.qbon];
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
  
  LHIdeaFeatureViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ideaCardViewCell"];
  
  if (todayObject.ideaPointer.graphicPointer) {
    
    cell.ideaImageView.image = [UIImage imageNamed:@"card_default"];
    cell.progressOverlayView.frame = cell.ideaImageView.bounds;
    
    PFFile* file = (PFFile*)todayObject.ideaPointer.graphicPointer.imageFile;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        LHIdeaFeatureViewCell* cell = (LHIdeaFeatureViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.ideaImageView.image = image;
        [cell setNeedsDisplay];
      }
    } progressBlock:^(int percentDone) {
      float perenctDownFloat = (float)percentDone / 100.f;
      NSLog(@"Download %@ progress: %f", file.url, perenctDownFloat);
      if (perenctDownFloat == 0) {
        [cell.progressOverlayView displayOperationWillTriggerAnimation];
        cell.progressOverlayView.hidden = NO;
      }
      if (perenctDownFloat < 1) {
        cell.progressOverlayView.progress = perenctDownFloat;
      } else {
        [cell.progressOverlayView displayOperationDidFinishAnimation];
        double delayInSeconds = cell.progressOverlayView.stateChangeAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          cell.progressOverlayView.progress = 0.;
          cell.progressOverlayView.hidden = YES;
        });
        
      }
    }];

  }
  
  
  
  [cell.ideaTitleLabel setText:todayObject.ideaPointer.Name];
  [cell.ideaCardTitleLabel setText:NSLocalizedString(todayObject.type, @"Feature")
   ];
  [cell.ideaContentLabel setText:todayObject.ideaPointer.Description];

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
  return 620.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 620.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  if ([segue.identifier isEqual:@"pushIdeaCardViewController"]) {
    LHIdeaCardViewController *viewController = segue.destinationViewController;
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    LHToday *today = (LHToday *)[self objectAtIndexPath:selectedPath];
    [viewController setIdea:today.ideaPointer];
  }
  
  if  ([segue.identifier isEqualToString:@"PresendQbonWall"]) {
    LHQbonViewController *qbonViewController = segue.destinationViewController;
    qbonViewController.qbon.delegate = self;
  }
  
  if ([segue.identifier isEqual:@"presentPostViewController"]) {
      
      if (![PFUser currentUser]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"Need to login" message:@"Please login before share a story"];
        [alertView bk_addButtonWithTitle:@"Go" handler:^{
          [segue.destinationViewController dismissViewControllerAnimated:YES completion:^{
            LHLoginViewController *loginViewController =[[LHLoginViewController alloc] init];
            loginViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
            [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
          }];
          
        }];
        [alertView bk_setCancelBlock:^{
          [segue.destinationViewController dismissModalViewControllerAnimated:YES];
        }];
        [alertView show];
      } else {
        NSLog(@"Login User Name: %@", [[PFUser currentUser] username]);
      }
      
    }
  
  
}

#pragma mark - QbonDelegate

- (void)qbon:(id)qbon loginResult:(NSDictionary *)userData {
  
}

- (void)qbon:(id)qbon close:(BOOL)complete {
  if (complete) {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  }
}

@end

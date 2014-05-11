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
#import <Nimbus/NIWebController.h>

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
  
//  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//  UINavigationController *niWebViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"NavConformWeb"];
//  NIWebController *webController = (NIWebController *)niWebViewController.viewControllers[0];
//  [webController openURL:[NSURL URLWithString:kWebTermsOfUseUrl]];
//  
//  [self.navigationController presentViewController:niWebViewController animated:NO completion:nil];
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
  [cell.ideaContentLabel sizeToFit];
  [cell.categoryTitleLabel setText:todayObject.ideaPointer.categoryPointer.Name];
  
  if (todayObject.ideaPointer.doneCount.intValue > 1) {
    [cell.actionsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Done %i times", @"Done Times"), todayObject.ideaPointer.doneCount.intValue]];
    cell.actionsLabel.hidden = NO;
  } else if (todayObject.ideaPointer.doneCount.intValue == 1) {
    [cell.actionsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Done %i time", @"Done Time"), todayObject.ideaPointer.doneCount.intValue]];
    cell.actionsLabel.hidden = NO;
  } else {
    cell.actionsLabel.hidden = YES;
  }
  
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
  return 640.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 640.0f;
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
        
        UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:NSLocalizedString(@"Need to login",nil) message:NSLocalizedString(@"Please login before share a story", nil)];
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

- (void)qbon:(id)qbon close:(BOOL)complete {
  if (complete) {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGRect frame = self.navigationController.navigationBar.frame;
  CGFloat size = frame.size.height - 21;
  CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
  CGFloat scrollOffset = scrollView.contentOffset.y;
  CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
  CGFloat scrollHeight = scrollView.frame.size.height;
  CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
  
  if (scrollOffset <= -scrollView.contentInset.top) {
    frame.origin.y = 20;
  } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
    frame.origin.y = -size;
    
  } else {
    frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
  }
  
  [self.navigationController.navigationBar setFrame:frame];
  [self updateBarButtonItems:(1 - framePercentageHidden)];
  self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [self stoppedScrolling];
  }
}

- (void)stoppedScrolling {
  CGRect frame = self.navigationController.navigationBar.frame;
  if (frame.origin.y < 20) {
    [self animateNavBarTo:-(frame.size.height - 21)];
  }
}

- (void)updateBarButtonItems:(CGFloat)alpha {
  [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
    item.customView.alpha = alpha;
  }];
  [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
    item.customView.alpha = alpha;
  }];
  self.navigationItem.titleView.alpha = alpha;
  [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [[UIColor whiteColor] colorWithAlphaComponent:alpha],
                                                                   NSForegroundColorAttributeName,
                                                                   nil]];
  
  self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y {
  [UIView animateWithDuration:0.2 animations:^{
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
    frame.origin.y = y;
    [self.navigationController.navigationBar setFrame:frame];
    [self updateBarButtonItems:alpha];
  }];
}

@end

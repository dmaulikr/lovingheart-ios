//
//  LHIdeaListViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/31.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdeaListViewController.h"
#import "LHIdea.h"
#import "LHIdeaCardCell.h"
#import "LHIdeaCardViewController.h"
#import <UIAlertView+BlocksKit.h>
#import "LHLoginViewController.h"
#import "DAProgressOverlayView.h"

@implementation LHIdeaListViewController

- (void)awakeFromNib {
  self.parseClassName = @"Idea";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 10;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHIdea query];

  [query includeKey:@"graphicPointer"];
  [query includeKey:@"categoryPointer"];
  [query whereKey:@"status" notEqualTo:@"close"];
  
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
                        object:(LHIdea *)ideaObject {
  
  LHIdeaCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ideaCardViewCell"];
  
  if (ideaObject.graphicPointer) {
    
    cell.ideaImageView.image = [UIImage imageNamed:@"card_default"];
    cell.progressOverlayView.frame = cell.ideaImageView.bounds;
    
    PFFile* file = (PFFile*)ideaObject.graphicPointer.imageFile;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        LHIdeaCardCell* cell = (LHIdeaCardCell*)[self.tableView cellForRowAtIndexPath:indexPath];
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

  [cell.categoryTitleLabel setText:ideaObject.categoryPointer.Name];
  [cell.ideaTitleLabel setText:ideaObject.Name];
  [cell.ideaTitleLabel sizeToFit];
  
  [cell.ideaDescriptionLabel setText:ideaObject.Description];
  [cell.ideaDescriptionLabel sizeToFit];
  
  if (ideaObject.doneCount.intValue > 1) {
    [cell.ideaDoneCountLabel setText:[NSString stringWithFormat:@"Done %i times", ideaObject.doneCount.intValue]];
    cell.ideaDoneCountLabel.hidden = NO;
  } else if (ideaObject.doneCount.intValue == 1) {
    [cell.ideaDoneCountLabel setText:[NSString stringWithFormat:@"Done %i time", ideaObject.doneCount.intValue]];
    cell.ideaDoneCountLabel.hidden = NO;
  } else {
    cell.ideaDoneCountLabel.hidden = YES;
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
  
  if (indexPath.row < self.objects.count) {
    LHIdea *currentIdea = (LHIdea *)[self.objects objectAtIndex:indexPath.row];
    
    //Calculate the expected size based on the font and linebreak mode of your label
    CGSize maximumIdeaContentLabelSize = CGSizeMake(320.f, FLT_MAX);
    
    NSDictionary *stringArrtibutes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17.f] forKey:NSFontAttributeName];
    
    CGSize expectedIdeaTitleSize = [currentIdea.Name boundingRectWithSize:maximumIdeaContentLabelSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringArrtibutes context:nil].size;
    
    CGSize expectedIdeaDescriptionSize = [currentIdea.Description boundingRectWithSize:maximumIdeaContentLabelSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringArrtibutes context:nil].size;
    
    return expectedIdeaTitleSize.height + expectedIdeaDescriptionSize.height + 320 + 140;
  }
  
  return 140.f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqual:@"pushIdeaCardViewController"]) {
    LHIdeaCardViewController *viewController = segue.destinationViewController;
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    LHIdea *idea = (LHIdea *)[self objectAtIndexPath:selectedPath];
    [viewController setIdea:idea];
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

@end

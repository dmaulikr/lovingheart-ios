//
//  LHIdeaCardViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdeaCardViewController.h"
#import "UIView+Frame.h"
#import "LHPostStoryViewController.h"
#import "LHStoriesFromCardViewController.h"
#import "NIWebController.h"
#import "LHLoginViewController.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>

@interface LHIdeaCardViewController ()

@end

@implementation LHIdeaCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)objectToViews {
  self.ideaCardImageView.clipsToBounds = YES;
  if (self.idea.graphicPointer) {
    PFFile* file = (PFFile*)self.idea.graphicPointer.imageFile;
    __block UIImageView *__cardImageView = self.ideaCardImageView;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        __cardImageView.image = image;
        [__cardImageView setNeedsDisplay];
      }
    }];
  }
  
  [_categoryTitleLabel setText:self.idea.categoryPointer.Name];
  [_ideaTitleLabel setText:self.idea.Name];
  [_ideaContentLabel setText:self.idea.Description];
  
  _readStoriesButton.enabled = YES;
  if (self.idea.doneCount.intValue == 1) {
    [_readStoriesButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Read %i Action", nil), self.idea.doneCount.intValue] forState:UIControlStateNormal];
  } else if (self.idea.doneCount.intValue > 1) {
    [_readStoriesButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Read %i Actions", nil), self.idea.doneCount.intValue] forState:UIControlStateNormal];
  } else {
    _readStoriesButton.enabled = NO;
  }
  
  self.callToActionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  if (self.idea.webUrl && self.idea.webUrlActionCall ) {
    [self.callToActionButton setTitle:self.idea.webUrlActionCall forState:UIControlStateNormal];
    self.callToActionButton.enabled = YES;
  } else {
    self.callToActionButton.enabled = NO;
    self.callToActionButton.hidden = YES;
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  __block LHIdeaCardViewController *__self = self;
  PFQuery *query = [LHIdea query];
  [query includeKey:@"categoryPointer"];
  [query includeKey:@"graphicPointer"];
  [query getObjectInBackgroundWithId:self.idea.objectId block:^(PFObject *object, NSError *error) {
    if (!error) {
      __self.idea = (LHIdea *)object;
      [__self objectToViews];
      [__self viewDidLayoutSubviews];
    }
  }];
  [self objectToViews];
}

- (void)viewDidLayoutSubviews {
  
  // Adjust height depending on the text
  
  //Calculate the expected size based on the font and linebreak mode of your label
  CGSize maximumIdeaContentLabelSize = CGSizeMake(self.ideaContentLabel.frame.size.width, FLT_MAX);
  
  NSDictionary *stringArrtibutes = [NSDictionary dictionaryWithObject:self.ideaContentLabel.font forKey:NSFontAttributeName];
  
  CGSize expectedIdeaContentLabelSize = [self.ideaContentLabel.text boundingRectWithSize:maximumIdeaContentLabelSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringArrtibutes context:nil].size;
  
  // Adjust the label to the new height
  self.ideaContentLabel.frame = CGRectMake(self.ideaContentLabel.frame.origin.x, self.ideaContentLabel.frame.origin.y, expectedIdeaContentLabelSize.width, expectedIdeaContentLabelSize.height);
  
  [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width,
                             self.readStoriesButton.bottom + 20
                                                )];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"shareStorySegue"]) {
    
    if (![PFUser currentUser]) {
      
      UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:NSLocalizedString(@"Need to login",nil) message:NSLocalizedString(@"Please login before share a story",nil)];
      [alertView bk_addButtonWithTitle:NSLocalizedString(@"Go", nil) handler:^{
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
      
      UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
      if (navigationController.viewControllers.count > 0) {
        LHPostStoryViewController *postStoryViewController = (LHPostStoryViewController *)navigationController.viewControllers[0];
        [postStoryViewController setIdeaObject:self.idea];
        
      }
    }
    

  }
  if ([segue.identifier isEqualToString:@"readStoriesFromCard"]) {
    LHStoriesFromCardViewController *tableViewController = (LHStoriesFromCardViewController *)segue.destinationViewController;
    [tableViewController setIdeaObject:self.idea];
  }
  if ([segue.identifier isEqualToString:@"CallToAction"]) {
    NIWebController *webController = segue.destinationViewController;
    webController.edgesForExtendedLayout = UIRectEdgeNone;
    [webController openURL:[NSURL URLWithString:self.idea.webUrl]];
  }
}


@end

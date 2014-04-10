//
//  LHStoryViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/25.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoryViewController.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import <AFNetworking/AFNetworking.h>
#import <UIGestureRecognizer+BlocksKit.h>
#import "LHUserProfileViewController.h"
#import <BlocksKit/UIActionSheet+BlocksKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface LHStoryViewController ()

@end

@implementation LHStoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}


- (void)loadViewFromObject {
  self.avatarImageView.layer.cornerRadius = 25;
  self.avatarImageView.layer.masksToBounds = YES;
  self.avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
  if (self.story.StoryTeller.avatar) {
    NSURL* imageUrl = [NSURL URLWithString:self.story.StoryTeller.avatar.imageUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    __block UIImageView *__avatarImageView = self.avatarImageView;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      __avatarImageView.image = responseObject;
    } failure:nil];
    
    [operation start];
  }
  UITapGestureRecognizer *singleTap =  [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
    if (state == UIGestureRecognizerStateEnded) {
      
      UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      
      LHUserProfileViewController *profileViewController = [sb instantiateViewControllerWithIdentifier:@"LHUserProfileViewController"];
      [profileViewController setUser:self.story.StoryTeller];
      [self.navigationController pushViewController:profileViewController animated:YES];
    }
  }];
  [singleTap setNumberOfTapsRequired:1];
  [self.avatarImageView addGestureRecognizer:singleTap];
  
  self.storyImageView.clipsToBounds = YES;
  
  if (self.story.graphicPointer) {
    PFFile* file = (PFFile*)self.story.graphicPointer.imageFile;
    __block UIImageView *__storyImageView = self.storyImageView;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        self.storyImageView.hidden = NO;
        UIImage *image = [UIImage imageWithData:data];
        __storyImageView.image = image;
        [__storyImageView setNeedsDisplay];
      }
    }];
  } else {
    self.storyImageView.hidden = YES;
  }
  
  [self.userNameLabel setText:self.story.StoryTeller.name];
  [self.storyContentLabel setText:self.story.Content];
  [self.storyContentLabel setNumberOfLines:0];
  [self.storyContentLabel sizeToFit];
  
  self.storyLocationLabel.text = self.story.areaName;
  self.storyDateLabel.text = [self.story.createdAt timeAgo];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  NSLog(@"Story Content: %@", self.story.Content);
  
  [self loadViewFromObject];
  self.shareButton.target = self;
  self.shareButton.action = @selector(shareButtonClicked:);
  
  if (!self.story.Content) {
    
    __block LHStoryViewController *__self = self;
    PFQuery *query = [LHStory query];
    [query includeKey:@"StoryTeller"];
    [query includeKey:@"StoryTeller.avatar"];
    [query includeKey:@"graphicPointer"];
    [query includeKey:@"ideaPointer"];
    [query getObjectInBackgroundWithId:self.story.objectId block:^(PFObject *object, NSError *error) {
      if (!error) {
        __self.story = (LHStory *)object;
        [__self loadViewFromObject];
      }
    }];
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)shareButtonClicked:(id)sender {
  UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"Share"];
  __block UIActionSheet *__actionSheet = actionSheet;
  [actionSheet bk_addButtonWithTitle:@"Share to Facebook" handler:^{
    FBRequest *fbRequest = [FBRequest requestForMe];
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:[NSString stringWithFormat:@"http://tw.lovingheartapp.com/story/%@", self.story.objectId]];
    if ([self.story.status isEqualToString:@"anonymous"]) {
      params.name = @"Anonymous";
    } else {
      params.name = self.story.StoryTeller.name;
    }
    if (self.story.ideaPointer) {
      PFObject *idea = [self.story.ideaPointer fetchIfNeeded];
      params.caption = idea[@"Name"];
    } else {
      params.caption = @"This story has inspired me.";
    }
    if ([self.story.graphicPointer.imageType isEqualToString:@"file"]) {
      params.picture = [NSURL URLWithString:self.story.graphicPointer.imageFile.url];
    } else if (self.story.graphicPointer.imageUrl) {
      params.picture = [NSURL URLWithString:self.story.graphicPointer.imageUrl];
    }
    
    params.description = self.story.Content;
    
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
      [FBDialogs presentShareDialogWithLink:params.link name:params.name caption:params.caption description:params.description picture:params.picture clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        if (error) {
          NSLog(@"Error publishing story: %@", error.description);
        } else {
          NSLog(@"result %@", results);
          [SVProgressHUD showSuccessWithStatus:@"Share to Facebook successfully."];
        }
      }];
    } else {
      // Put together the dialog parameters
      NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               params.name, @"name",
                                               params.caption, @"caption",
                                               params.description, @"description",
                                               [params.link absoluteString], @"link",
                                               [params.picture absoluteString], @"picture",
                                               nil];
      
      // Show the feed dialog
      [FBWebDialogs presentFeedDialogModallyWithSession:fbRequest.session
                                             parameters:paramsDictionary
                                                handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                    // An error occurred, we need to handle the error
                                                    // See: https://developers.facebook.com/docs/ios/errors
                                                    NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                    if (result == FBWebDialogResultDialogNotCompleted) {
                                                      // User cancelled.
                                                      NSLog(@"User cancelled.");
                                                    } else {
                                                      // Handle the publish feed callback
                                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                      
                                                      if (![urlParams valueForKey:@"post_id"]) {
                                                        // User cancelled.
                                                        NSLog(@"User cancelled.");
                                                        
                                                      } else {
                                                        // User clicked the Share button
                                                        NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                        NSLog(@"result %@", result);
                                                        [SVProgressHUD showSuccessWithStatus:@"Share to Facebook successfully."];
                                                      }
                                                    }
                                                  }
                                                }];
    }
  }];
  [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:^{
    [__actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  }];
  [actionSheet showInView:self.view];
  
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
  NSArray *pairs = [query componentsSeparatedByString:@"&"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  for (NSString *pair in pairs) {
    NSArray *kv = [pair componentsSeparatedByString:@"="];
    NSString *val =
    [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    params[kv[0]] = val;
  }
  return params;
}

@end

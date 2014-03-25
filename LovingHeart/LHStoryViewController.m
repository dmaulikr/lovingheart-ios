//
//  LHStoryViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/25.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHStoryViewController.h"
#import <AFNetworking/AFNetworking.h>

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


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  NSLog(@"Story Content: %@", self.story.Content);

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
  
  self.storyImageView.clipsToBounds = YES;
  if (self.story.graphicPointer) {
    PFFile* file = (PFFile*)self.story.graphicPointer.imageFile;
    __block UIImageView *__storyImageView = self.storyImageView;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        __storyImageView.image = image;
        [__storyImageView setNeedsDisplay];
      }
    }];
  }
  
  [self.userNameLabel setText:self.story.StoryTeller.name];
  [self.storyContentLabel setText:self.story.Content];
  [self.storyContentLabel setNumberOfLines:0];
  [self.storyContentLabel sizeToFit];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

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

//
//  LHUserViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/1.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHUserViewController.h"
#import "LHUser.h"
#import <AFNetworking/AFNetworking.h>

@interface LHUserViewController ()

@end

@implementation LHUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)awakeFromNib {
  self.avatarImageView.layer.cornerRadius = 40;
  self.avatarImageView.layer.masksToBounds = YES;
  self.avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
  
  self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 1000);
  
  _refreshControl = [[UIRefreshControl alloc] init];
  [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
  [self.scrollView addSubview:_refreshControl];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self awakeFromNib];
  
  [self queryUserInfo];

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

- (void)refresh:(id)sender {
  [self queryUserInfo];
}

- (void)queryUserInfo {
  // Query current User
  if ([PFUser currentUser]) {
    PFQuery *currentUserQuery = [LHUser query];
    [currentUserQuery includeKey:@"avatar"];
    [currentUserQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    currentUserQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [currentUserQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (!error) {
        LHUser *userObject = (LHUser *)object;
        [_userNameLabel setText:userObject[@"name"]];
        
        if (userObject.avatar) {
          NSURL* imageUrl = [NSURL URLWithString:userObject.avatar.imageUrl];
          NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
          AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
          operation.responseSerializer = [AFImageResponseSerializer serializer];
          
          __block UIImageView *__avatarImageView = self.avatarImageView;
          [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __avatarImageView.image = responseObject;
          } failure:nil];
          
          [operation start];
        }
      }
      if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
      }
      
    }];
    
    PFQuery *userImpactQuery = [LHUserImpact query];
    [userImpactQuery whereKey:@"User" equalTo:[PFUser currentUser]];
    userImpactQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [userImpactQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (!error) {
        LHUserImpact *userImpact = (LHUserImpact *)object;
        [self.numbersOfPostsLabel setText:[NSString stringWithFormat:@"%i", userImpact.sharedStoriesCount.intValue]];
        [self.numbersOfGraphicsLabel setText:[NSString stringWithFormat:@"%i", userImpact.graphicsEarnedCount.intValue]];
        [self.numbersOfEnergyLabel setText:[NSString stringWithFormat:@"%i", userImpact.reviewStarsImpact.intValue]];
      }
      if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
      }
    }];
  }
}

@end

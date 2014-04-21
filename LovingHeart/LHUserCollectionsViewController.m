//
//  LHUserCollectionsViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/14.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHUserCollectionsViewController.h"
#import "LHUserInfoCell.h"
#import "LHReportViewCell.h"
#import "LHStateInfoCell.h"

@interface LHUserCollectionsViewController ()

@end

@implementation LHUserCollectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _refreshControl = [[UIRefreshControl alloc] init];
  [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
  [self.collectionView addSubview:_refreshControl];
  self.collectionView.alwaysBounceVertical = YES;
  
  [self queryUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    LHUserInfoCell *userInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserInfoCell" forIndexPath:indexPath];
    return userInfoCell;
  }
  if (indexPath.row == 1) {
    LHStateInfoCell *stateInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StateInfoCell" forIndexPath:indexPath];
    stateInfoCell.stateLabel.text = @"5 posts";
    return stateInfoCell;
  }
  if (indexPath.row == 2) {
    LHStateInfoCell *stateInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StateInfoCell" forIndexPath:indexPath];
    stateInfoCell.stateLabel.text = @"6 graphics";
    return stateInfoCell;
  }
  if (indexPath.row == 3) {
    LHStateInfoCell *stateInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StateInfoCell" forIndexPath:indexPath];
    stateInfoCell.stateLabel.text = @"50 energy";
    return stateInfoCell;
  }
  if (indexPath.row >= 4) {
    LHReportViewCell *reportCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextReportCell" forIndexPath:indexPath];
    reportCell.textLabel.text = @"Report text show that";
    return reportCell;
  }
  
  NSString *Identifier = @"emptyCell";
  UICollectionViewCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
  return emptyCell;
}

- (void)queryUserInfo {
  // Query current User
  if (self.user) {
    PFQuery *currentUserQuery = [LHUser query];
    [currentUserQuery includeKey:@"avatar"];
    [currentUserQuery whereKey:@"objectId" equalTo:self.user.objectId];
    currentUserQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    if (![self.refreshControl isRefreshing]) {
      [self.refreshControl beginRefreshing];
    }
    
    [currentUserQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (!error) {
        LHUser *userObject = (LHUser *)object;
        
        LHUserInfoCell *userInfoCell = (LHUserInfoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [userInfoCell.userNameLabel setText:userObject[@"name"]];
        
        if (userObject.avatar) {
          NSURL* imageUrl = [NSURL URLWithString:userObject.avatar.imageUrl];
          NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
          AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
          operation.responseSerializer = [AFImageResponseSerializer serializer];
          
          __block UIImageView *__avatarImageView = userInfoCell.userAvatarImageView;
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
    
//    PFQuery *userImpactQuery = [LHUserImpact query];
//    [userImpactQuery whereKey:@"User" equalTo:self.user];
//    userImpactQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    [userImpactQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//      if (!error) {
//        LHUserImpact *userImpact = (LHUserImpact *)object;
//        [self.numbersOfPostsLabel setText:[NSString stringWithFormat:@"%i", userImpact.sharedStoriesCount.intValue]];
//        [self.numbersOfPostsButton setTitle:[NSString stringWithFormat:@"%i\nposts", userImpact.sharedStoriesCount.intValue] forState:UIControlStateNormal];
//        [self.numbersOfPostsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        self.numbersOfPostsButton.enabled = (userImpact.sharedStoriesCount.intValue > 0);
//        
//        [self.numbersOfGraphicsButton setTitle:[NSString stringWithFormat:@"%i\ngraphics", userImpact.graphicsEarnedCount.intValue] forState:UIControlStateNormal];
//        [self.numbersOfGraphicsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        self.numbersOfGraphicsButton.enabled = (userImpact.graphicsEarnedCount.intValue > 0);
//        
//        [self.numbersOfEnergyButton setTitle:[NSString stringWithFormat:@"%i\nenergy", userImpact.reviewStarsImpact.intValue] forState:UIControlStateNormal];
//        [self.numbersOfEnergyButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        self.numbersOfEnergyButton.enabled = (userImpact.reviewStarsImpact.intValue > 0);
//      }
//      if ([self.refreshControl isRefreshing]) {
//        [self.refreshControl endRefreshing];
//      }
//    }];
  }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"didSelectItemAtIndexPath %@", indexPath);
}

- (void)refresh:(id)sender {
  [self queryUserInfo];
}

@end

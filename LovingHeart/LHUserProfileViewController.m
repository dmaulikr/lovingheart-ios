//
//  LHUserProfileViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/4.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHUserProfileViewController.h"
#import "LHPickerTableViewCell.h"

@interface LHUserProfileViewController ()

@end

@implementation LHUserProfileViewController {
  int tableViewContentHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
  
  self.title = NSLocalizedString(@"User Profile", @"User Profile");
  
  _stories = [[NSMutableArray alloc] init];
  _reportWords = [[NSMutableArray alloc] init];
  
  _userReportTableView = [[UITableView alloc] init];
  self.userReportTableView.delegate = self;
  self.userReportTableView.dataSource = self;
  
  self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2;
  self.avatarImageView.layer.masksToBounds = YES;
  self.avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
  
  _refreshControl = [[UIRefreshControl alloc] init];
  [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
  [self.userProfileScrollView addSubview:_refreshControl];
  
    [self.userProfileScrollView addSubview:self.userReportTableView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self awakeFromNib];
  
  self.userTableView.hidden = YES;
  [self queryUserInfo];
  [self queryUserStories];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  self.userReportTableView.frame = CGRectMake(self.avatarImageView.left, self.userTableView.top, self.userTableView.width, tableViewContentHeight);
  
  self.userProfileScrollView.contentSize = CGSizeMake(self.userProfileScrollView.width, self.userReportTableView.bottom + 10);
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

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
  [self resetUser];
  [self queryUserInfo];
}

- (void)resetUser {
}

- (void)queryUserStories {
  if (self.user) {
    PFQuery *query = [LHStory query];
    
    [query includeKey:@"StoryTeller"];
    [query includeKey:@"StoryTeller.avatar"];
    [query includeKey:@"graphicPointer"];
    [query includeKey:@"ideaPointer"];
    
    [query whereKey:@"StoryTeller" equalTo:self.user];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.stories.count == 0) {
      query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
        [self.stories removeAllObjects];
        [self.stories addObjectsFromArray:objects];
        
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        // Add to report
        for(LHStory *eachStory in objects) {
          [tags addObjectsFromArray:[eachStory.Tags componentsSeparatedByString:@","]];
          [tags addObjectsFromArray:[eachStory.ideaPointer.Tags componentsSeparatedByString:@","]];
        }
        NSLog(@"Tags: %@", tags);
        [_reportWords removeAllObjects];
        [_reportWords addObjectsFromArray:tags];
        
        [self.userReportTableView reloadData];
      }
      
    }];
  }
}

- (void)queryUserInfo {
  // Query current User
  if (self.user) {
    PFQuery *currentUserQuery = [LHUser query];
    [currentUserQuery includeKey:@"avatar"];
    [currentUserQuery whereKey:@"objectId" equalTo:self.user.objectId];
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
    [userImpactQuery whereKey:@"User" equalTo:self.user];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _reportWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *identifier = @"uitableviewcell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  NSString *reportWord = [_reportWords objectAtIndex:indexPath.row];
  [cell.textLabel setText:[reportWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  int height = 48;
  if (indexPath.row == 0) {
    tableViewContentHeight = height;
  } else {
    tableViewContentHeight += height;
  }
  
  return height;
  
}

@end

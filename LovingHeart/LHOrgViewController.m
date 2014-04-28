//
//  LHOrgViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHOrgViewController.h"
#import "LHOrgCollectionViewCell.h"
#import "LHEventsTableViewController.h"
#import "LHQbonViewController.h"
#import <BlocksKit/UIControl+BlocksKit.h>

@interface LHOrgViewController ()

@end

@implementation LHOrgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  _orgLists = [[NSMutableArray alloc] init];
  
  __block LHOrgViewController *__self = self;
  _refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl bk_addEventHandler:^(id sender) {
    [__self query];
  } forControlEvents:UIControlEventValueChanged];
  [self.collectionView addSubview:self.refreshControl];
  
  self.collectionView.alwaysBounceVertical = YES;
  
  [self query];
}

- (void)query {
  PFQuery *orgQuery = [LHOrganizer query];
  [orgQuery includeKey:@"graphicPointer"];
  [orgQuery orderByAscending:@"createdAt"];
  [orgQuery whereKey:@"status" notEqualTo:@"close"];
  __block LHOrgViewController *__self = self;

  [orgQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    [_refreshControl endRefreshing];
    if (objects && !error) {
      [__self.orgLists removeAllObjects];
      [__self.orgLists addObjectsFromArray:objects];
      [__self.collectionView reloadData];
    }
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _orgLists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell;
  
  if (!cell) {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrgCollectionViewCell" forIndexPath:indexPath];
  }
  
  LHOrganizer *currentOrg = [self.orgLists objectAtIndex:indexPath.row];
  
  if (currentOrg.graphicPointer) {
    PFFile* file = (PFFile*)currentOrg.graphicPointer.imageFile;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        LHOrgCollectionViewCell* cell = (LHOrgCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.orgImageView.image = image;
        [cell setNeedsDisplay];
      }
    } progressBlock:^(int percentDone) {
      float perenctDownFloat = (float)percentDone / 100.f;
    }];
  }
  LHOrgCollectionViewCell* orgCell = (LHOrgCollectionViewCell*)cell;
  orgCell.titleLabel.text = currentOrg.name;
  orgCell.organizer = currentOrg;
  
  if (!cell) {
    cell = [[UICollectionViewCell alloc] init];
  }
  
  return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"PushToEvents"]) {
    LHEventsTableViewController *eventsTableViewController = (LHEventsTableViewController *)segue.destinationViewController;
    
    LHOrgCollectionViewCell *selectedCell = (LHOrgCollectionViewCell *)sender;
    eventsTableViewController.organizer = selectedCell.organizer;
  }
  
  if  ([segue.identifier isEqualToString:@"PresendQbonWall"]) {
    LHQbonViewController *qbonViewController = segue.destinationViewController;
    qbonViewController.qbon.delegate = self;
  }
}

#pragma mark - QbonDelegate

- (void)qbon:(id)qbon close:(BOOL)complete {
  if (complete) {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  }
}


@end

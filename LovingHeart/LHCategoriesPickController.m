//
//  LHCategoriesPickController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/2.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHCategoriesPickController.h"
#import "LHPickerTableViewCell.h"
#import <BlocksKit/UIControl+BlocksKit.h>

@interface LHCategoriesPickController ()

@end

@implementation LHCategoriesPickController {
  CategoryPickDidSelectRowAtIndexPath _categoryPickDidSelectRowAtIndexPath;
  CategoryPickClearSelectRowAtIndexPath _categoryPickClearSelectRowAtIndexPath;
}

- (void)awakeFromNib {
  self.parseClassName = @"Category";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 20;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  [self.cancelButtonItem setTarget:self];
  [self.cancelButtonItem setAction:@selector(cancel:)];
  
  self.allButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  self.allButton.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
  [self.allButton bk_addEventHandler:^(id sender) {
    _categoryPickClearSelectRowAtIndexPath();
    [self performSelector:@selector(cancel:) withObject:nil];
  } forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)cancel:(id)select {
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (PFQuery *)queryForTable {
  PFQuery *query = [LHCategory query];
  
  [query whereKey:@"language" containedIn:[LHAltas supportLanguageList]];
  
  // If no objects are loaded in memory, we look to the cache first to fill the table
  // and then subsequently do a query against the network.
  if (self.objects.count == 0) {
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 60 * 5;
  }
  
  [query orderByDescending:@"createdAt"];
  
  return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(LHCategory *)categoryObject {
  
  LHPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHPickerTableViewCell"];
  [cell.titleLabel setText:categoryObject.Name];
  if (self.selectedCategory && [self.selectedCategory.objectId isEqualToString:categoryObject.objectId]) {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else {
    [cell setAccessoryType:UITableViewCellAccessoryNone];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self dismissViewControllerAnimated:YES completion:^{
    if (_categoryPickDidSelectRowAtIndexPath) {
      _categoryPickDidSelectRowAtIndexPath(indexPath, [self.objects objectAtIndex:indexPath.row]);
    }
    
  }];
}

- (void)clearSelectedRowAtIndexPath:(CategoryPickClearSelectRowAtIndexPath)clearSelect {
  _categoryPickClearSelectRowAtIndexPath = clearSelect;
}

- (void)setDidSelectedRowAtIndexPath:(CategoryPickDidSelectRowAtIndexPath)didSelectRowAtIndexPath {
  _categoryPickDidSelectRowAtIndexPath = didSelectRowAtIndexPath;
}

@end

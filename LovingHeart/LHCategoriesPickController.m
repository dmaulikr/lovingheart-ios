//
//  LHCategoriesPickController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/2.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHCategoriesPickController.h"
#import "LHPickerTableViewCell.h"

@interface LHCategoriesPickController ()

@end

@implementation LHCategoriesPickController {
  CategoryPickDidSelectRowAtIndexPath _categoryPickDidSelectRowAtIndexPath;
}

- (void)awakeFromNib {
  self.parseClassName = @"Category";
  self.pullToRefreshEnabled = YES;
  self.paginationEnabled = YES;
  self.objectsPerPage = 10;
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

- (void)setDidSelectedRowAtIndexPath:(CategoryPickDidSelectRowAtIndexPath)didSelectRowAtIndexPath {
  _categoryPickDidSelectRowAtIndexPath = didSelectRowAtIndexPath;
}

@end

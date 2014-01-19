//
//  StoryTimelineViewController.m
//  LovingHeart
//
//  Created by zeta on 2014/1/19.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "StoryTimelineViewController.h"
#import "StoryCell.h"
#import <AFNetworking/AFNetworking.h>

@interface StoryTimelineViewController ()

@end

@implementation StoryTimelineViewController

- (void)awakeFromNib {
    self.parseClassName = @"Story";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 10;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    [query includeKey:@"StoryTeller"];
    [query includeKey:@"StoryTeller.avatar"];
    [query includeKey:@"graphicPointer"];
    
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
                        object:(PFObject *)object
{
    StoryCell *cell;
    if (object[@"graphicPointer"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"storyImageCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell"];
    }
    
    cell.nameLabel.text = object[@"StoryTeller"][@"name"];
    cell.contentLabel.text = object[@"Content"];
    cell.avatarView.image = [UIImage imageNamed:@"defaultAvatar"];
    
    if (object[@"StoryTeller"][@"avatar"]) {
        NSURL* imageUrl = [NSURL URLWithString:object[@"StoryTeller"][@"avatar"][@"imageUrl"]];
        NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            StoryCell* cell = (StoryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.avatarView.image = responseObject;
        } failure:nil];
        
        [operation start];
    }
    
    if (object[@"graphicPointer"]) {
        cell.pictureView.image = [UIImage imageNamed:@"pics.png"];
        PFFile* file = (PFFile*) object[@"graphicPointer"][@"imageFile"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                StoryCell* cell = (StoryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                cell.pictureView.image = image;
                [cell setNeedsDisplay];
            }
        }];
    }
    
    cell.locationLabel.text = object[@"areaName"];
    cell.timeLabel.text = object[@"createdAt"];

    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.objects.count) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    PFObject* object = [self objectAtIndexPath:indexPath];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath object:object];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints.
    // (Note that you must set the preferredMaxLayoutWidth on multi-line UILabels inside the -[layoutSubviews] method
    // of the UITableViewCell subclass, or do it manually at this point before the below 2 lines!)
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell's contentView
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1.0f;
    
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}


@end

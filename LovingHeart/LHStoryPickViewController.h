//
//  LHStoryPickViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/31.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^StoryPickDidSelectRowAtIndexPath)(NSIndexPath *indexPath);

@interface LHStoryPickViewController : UITableViewController

@property (nonatomic, strong) NSIndexSet *selected;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;

- (void)setDidSelectedRowAtIndexPath:(StoryPickDidSelectRowAtIndexPath)didSelectRowAtIndexPath;

@end

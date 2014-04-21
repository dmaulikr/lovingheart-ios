//
//  LHStoryViewTableViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/21.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHStoryViewTableViewController : UITableViewController

@property (nonatomic, strong) LHStory *story;
@property (nonatomic, strong) NSArray *events;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

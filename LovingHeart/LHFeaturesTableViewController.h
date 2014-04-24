//
//  LHFeaturesTableViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QbonWidget/Qbon.h>

@interface LHFeaturesTableViewController : PFQueryTableViewController
<
  QbonDelegate
>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *qbonButtonItem;

@end

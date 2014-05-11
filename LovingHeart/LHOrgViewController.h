//
//  LHOrgViewController.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QbonWidget/Qbon.h>

@interface LHOrgViewController : UICollectionViewController
<
QbonDelegate
>

@property (nonatomic, strong) NSMutableArray *orgLists;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

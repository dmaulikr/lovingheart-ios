//
//  LHUserImpact.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/1.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHUserImpact : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) PFUser *User;
@property (nonatomic, strong) NSNumber *sharedStoriesCount;
@property (nonatomic, strong) NSNumber *graphicsEarnedCount;
@property (nonatomic, strong) NSNumber *reviewStarsImpact;

@end

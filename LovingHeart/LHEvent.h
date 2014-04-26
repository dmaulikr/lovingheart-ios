//
//  LHEvent.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/21.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHEvent : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) LHUser *user;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) LHStory *story;

@end

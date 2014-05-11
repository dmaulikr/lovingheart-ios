//
//  LHIdeaGroup.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHIdeaGroup : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) LHOrganizer *Organizer;
@property (nonatomic, strong) NSString *Description;

@end

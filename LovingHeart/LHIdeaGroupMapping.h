//
//  LHIdeaGroupMapping.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHIdeaGroupMapping : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) LHIdeaGroup *IdeaGroup;
@property (nonatomic, strong) LHIdea *Idea;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *Name;

@end

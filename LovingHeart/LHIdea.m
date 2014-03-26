//
//  Idea.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/24.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdea.h"

@implementation LHIdea

@dynamic Name;
@dynamic Description;
@dynamic Tags;
@dynamic doneCount;

+ (NSString *)parseClassName {
  return @"Idea";
}

@end

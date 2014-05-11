//
//  LHToday.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LHIdea.h"

@interface LHToday : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) LHIdea *ideaPointer;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;

@end

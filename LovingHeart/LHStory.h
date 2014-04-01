//
//  LHStory.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/25.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHUser.h"
#import "LHGraphicImage.h"

@interface LHStory : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, retain) NSString *Content;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *Tags;
@property (nonatomic, retain) NSNumber *reviewImpact;
@property (nonatomic, strong) LHUser *StoryTeller;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) LHGraphicImage *graphicPointer;
@property (nonatomic, strong) PFGeoPoint *geoPoint;

@end

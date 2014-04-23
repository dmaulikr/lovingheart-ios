//
//  LHOrganizer.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/23.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHOrganizer : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) LHGraphicImage *graphicPointer;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *webUrl;

@end

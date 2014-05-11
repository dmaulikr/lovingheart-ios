//
//  Idea.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/24.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHGraphicImage.h"
#import "LHCategory.h"

@interface LHIdea : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSString *Tags;
@property (nonatomic, strong) NSNumber *doneCount;
@property (nonatomic, strong) LHGraphicImage *graphicPointer;
@property (nonatomic, strong) LHCategory *categoryPointer;
@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *webUrlActionCall;

@end

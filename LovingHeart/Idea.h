//
//  Idea.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/24.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Idea : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *Description;
@property (nonatomic, retain) NSString *Tags;
@property (nonatomic, retain) NSNumber *doneCount;

@end

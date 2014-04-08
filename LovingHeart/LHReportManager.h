//
//  LHReportManager.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/8.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHReportManager : NSObject

- (NSString *)analyzeStoriesTags:(NSMutableArray *)tags withUser:(LHUser *)user;

@end

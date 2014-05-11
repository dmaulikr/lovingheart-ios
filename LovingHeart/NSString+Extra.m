//
//  NSString+Extra.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/22.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "NSString+Extra.h"

@implementation NSString (Extra)

- (bool) contains: (NSString*) substring {
  NSRange range = [self rangeOfString:substring];
  return range.location != NSNotFound;
}

@end

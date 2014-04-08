//
//  LHAltas.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/1.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHAltas.h"

@implementation LHAltas

NSString* const kUserProfileRefreshNotification = @"kUserProfileRefreshNotification";

+ (NSArray *)supportLanguageList {
  // Load preference
  BOOL isSupportEnglish = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultSupportEnglish];
  BOOL isSupportChinese = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultSupportChinese];
  
  NSMutableArray *languageSupportList = [[NSMutableArray alloc] initWithCapacity:2];
  if (isSupportChinese) {
    [languageSupportList addObject:@"zh"];
  }
  if (isSupportEnglish) {
    [languageSupportList addObject:@"en"];
  }
  return languageSupportList;
}

@end

//
//  LHAltas.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/1.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHAltas : PFObject

#define kColorWithBlue [UIColor colorWithRed:0.169 green:0.471 blue:0.980 alpha:1]
#define kColorLovingHeartRed [UIColor colorWithRed:0.933 green:0.357 blue:0.365 alpha:1]

+ (NSArray *)supportLanguageList;

@end

static NSString *kUserDefaultSupportEnglish = @"kUserDefaultSupportEnglish";
static NSString *kUserDefaultSupportChinese = @"kUserDefaultSupportChinese";
static NSString *kUserDefaultHasBeenAskUser = @"kUserDefaultHasBeenAskUser";
static NSString *kUserDefaultUserWantPushNotification = @"kUserDefaultUserWantPushNotification";


extern NSString* const kUserProfileRefreshNotification;
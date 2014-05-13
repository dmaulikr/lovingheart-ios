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

static NSString *kWebAcknowledgementUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/333115-acknowledgement#anchor";
static NSString *kWebTermsOfUseUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/334311-terms-and-conditions-of-use#anchor";
static NSString *kPrivacyPolicyUrl = @"http://support.lovingheartapp.com/knowledgebase/articles/333113-privacy-policy#anchor";

static NSString *kAviaryAPIKey = @"d6fc6eb5fdda7a79";
static NSString *kAviarySecret = @"883fbc85c2e70208";

extern NSString* const kUserStoriesRefreshNotification;
extern NSString* const kUserProfileRefreshNotification;
extern NSString* const kUserStoryRefreshNotification;

extern int const kTabIdeasIndex;
extern int const kTabStoriesIndex;
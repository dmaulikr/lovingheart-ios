//
//  AppDelegate.m
//  LovingHeart
//
//  Created by zeta on 2014/1/12.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "AppDelegate.h"
#import "LHParseObject.h"
#import <UVConfig.h>
#import <uservoice-iphone-sdk/UserVoice.h>
#import "LHStoryViewController.h"
#import "LHMainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  [PFUser registerSubclass];
  [LHUser registerSubclass];
  [LHUserImpact registerSubclass];
  [LHStory registerSubclass];
  [LHToday registerSubclass];
  [LHIdea registerSubclass];
  [LHCategory registerSubclass];
  [LHGraphicImage registerSubclass];
  
  [Parse setApplicationId:@"5mqwxaAsD0xCUb8dh9HgFu4FM6bQOycBqx4XrdFL"
                clientKey:@"SX6e4Gd86Fq3vil6XOT4UHvrsfaBqvIJJ99vPkDV"];
  [PFFacebookUtils initializeFacebook];
  
  PFACL *defaultACL = [PFACL ACL];
  [defaultACL setPublicReadAccess:YES];
  [defaultACL setPublicWriteAccess:NO];
  [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
  
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  BOOL hasAskUserNotification = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultHasBeenAskUser];
  BOOL userWantPushNotification = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultUserWantPushNotification];
  if (hasAskUserNotification && userWantPushNotification) {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
  }
  
  [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xEC3D40, 1.0)];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UITabBar appearance] setTintColor:UIColorFromRGB(0xEC3D40, 1.0)];
  
  // Set this up once when your application launches
  UVConfig *config = [UVConfig configWithSite:@"lovingheart.uservoice.com"];
  config.topicId = 51969;
  config.forumId = 244037;
  [UserVoice initialize:config];
  
  // Initialize preference
  if ([NSLocale preferredLanguages] && [NSLocale preferredLanguages].count > 0) {
    NSString *userLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([userLanguage hasPrefix:@"en"] && ![[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSupportEnglish]) {
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultSupportEnglish];
    }
    if ([userLanguage hasPrefix:@"zh"] && ![[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSupportChinese]) {
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultSupportChinese];
    }
  }
  
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  // Store the deviceToken in the current Installation and save it to Parse.
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation setDeviceTokenFromData:deviceToken];
  if ([PFUser currentUser]) {
    [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
  }
  if ([NSLocale preferredLanguages]) {
    [currentInstallation setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"language"];
  }
  [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session] fallbackHandler:^(FBAppCall *call) {
    // Incoming link processing goes here
    // Retrieve the link associated with the post
    NSURL *targetURL = [[call appLinkData] targetURL];
    
    if (targetURL && [targetURL.absoluteString hasPrefix:@"http://tw.lovingheartapp.com"]) {
      NSArray *urlArray = [targetURL.absoluteString componentsSeparatedByString:@"/"];
      if (urlArray.count >= 4) {
        NSString *objectId = [urlArray objectAtIndex:(urlArray.count - 1)];
        NSString *object = [urlArray objectAtIndex:(urlArray.count - 2)];
        if ([object isEqualToString:@"story"]) {
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          LHStoryViewController *storyViewController = (LHStoryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StoryViewController"];
          
          LHStory *story = [[LHStory alloc] init];
          [story setObjectId:objectId];
          storyViewController.story = story;
          
          LHMainViewController *mainViewController = (LHMainViewController *)self.window.rootViewController;
          [mainViewController setSelectedIndex:2];
          
          [((UINavigationController *)mainViewController.selectedViewController) pushViewController:storyViewController animated:YES];
        }
      }
    }
 
  }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
  NSArray *pairs = [query componentsSeparatedByString:@"&"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  for (NSString *pair in pairs) {
    NSArray *kv = [pair componentsSeparatedByString:@"="];
    NSString *val = [[kv objectAtIndex:1]
                     stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [params setObject:val forKey:[kv objectAtIndex:0]];
  }
  return params;
}

@end

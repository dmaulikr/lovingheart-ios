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
  
  [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xEC3D40, 1.0)];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UITabBar appearance] setTintColor:UIColorFromRGB(0xEC3D40, 1.0)];
  
  // Set this up once when your application launches
  UVConfig *config = [UVConfig configWithSite:@"lovingheart.uservoice.com"];
  config.topicId = 51969;
  config.forumId = 244037;
  // [config identifyUserWithEmail:@"email@example.com" name:@"User Name", guid:@"USER_ID");
  [UserVoice initialize:config];
  
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
  [currentInstallation saveInBackground];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

@end

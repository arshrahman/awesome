//
//  AppDelegate.m
//  ToTe
//
//  Created by user on 31/12/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "AppDelegate.h"
#import "StartPageViewController.h"
#import "AppLaunch.h"
#import "Database.h"
#import "SettingsData.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if ([UITabBar instancesRespondToSelector:@selector(setSelectedImageTintColor:)])
    {
        //[[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
    }
    [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
    //[[UINavigationBar appearance]setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[[UITabBar appearance]setTintColor:[UIColor blackColor]];
    
    Database *d = [[Database alloc]init];
    [d CreateDB];
    
    AppLaunch *a = [[AppLaunch alloc]init];
    [a InsertPreviousBudget];
    
    //[a PostAllExpenses:3];
    //[a PostGoals:1];
    //[a GetBudgetByWeeks:3];
    //[a PostBudget];
    //[a PostToGoogleDocs];
    
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
    
    BOOL ShareData = [[NSUserDefaults standardUserDefaults]boolForKey:@"ShareSwitch"];
    
    if (ShareData)
    {
        AppLaunch *a = [[AppLaunch alloc]init];
        [a PrepareToPostGoogle];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    AppLaunch *a = [[AppLaunch alloc]init];
    [a InsertPreviousBudget];
    
    //[a GetSecureUID];
    //[a PostToGoogleDocs];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

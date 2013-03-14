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

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if ([UITabBar instancesRespondToSelector:@selector(setSelectedImageTintColor:)])
    {
        //[[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
    }
    [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
    //[[UINavigationBar appearance]setTintColor:[UIColor lightGrayColor]];
    //NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, nil];
    //[[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    //window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bground.jpg"]];
    
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    Database *d = [[Database alloc]init];
    [d CreateDB];
    
    AppLaunch *a = [[AppLaunch alloc]init];
    [a InsertPreviousBudget];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Time"])
    {
        NSDateComponents* backTime = [[NSDateComponents alloc]init];
    
        NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
        backTime = [cal components:NSHourCalendarUnit |
              NSMinuteCalendarUnit | NSSecondCalendarUnit
                    fromDate:[NSDate date]];
    
        int Time = ([backTime hour] *3600) + ([backTime minute] *60) + [backTime second];
    
        [[NSUserDefaults standardUserDefaults] setInteger:Time forKey:@"TimeSpan"];

        NSLog(@"%d Seconds", Time);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Time"])
    {
        NSDateComponents* foreTime = [[NSDateComponents alloc]init];
    
        NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
        foreTime = [cal components:NSHourCalendarUnit |
                   NSMinuteCalendarUnit | NSSecondCalendarUnit
                         fromDate:[NSDate date]];
    
        int CurrentTime = ([foreTime hour] *3600) + ([foreTime minute] *60) + [foreTime second];
    
        int TimeSpan = [[NSUserDefaults standardUserDefaults] integerForKey:@"TimeSpan"];
    
        TimeSpan = CurrentTime - TimeSpan;
    
        NSLog(@"%d Seconds", TimeSpan);
        
        [[NSUserDefaults standardUserDefaults] setInteger:TimeSpan forKey:@"TimeSpan"];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TimeCheck"];
    }
    
    AppLaunch *a = [[AppLaunch alloc]init];
    [a InsertPreviousBudget];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"App Killed");
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppKilled"];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

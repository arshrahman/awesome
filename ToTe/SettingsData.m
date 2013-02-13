//
//  SettingsData.m
//  ToTe
//
//  Created by user on 31/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "SettingsData.h"

@implementation SettingsData

@synthesize Facebook;
@synthesize Twitter;
@synthesize Share;

/*
 
 Weekly Message
 
 When :
 Weekly Budget set
 Hi everyone! I have decided to save $_____ for my goal (__________________) by __.__.__!Please support me by encouraging and reminding me!:D
 
 Weekly Budget met - "Goal Not Met":
 Yes! I have successfully saved this week for (__________________)! _____ weeks to go! I can achieve my goal! :D
 
 Weekly Budget not met - "Goal Not Met"
 Dang! I didn’t manage to save this week for (__________________):( Please continue to encourage & remind me! Let’s achieve our financial goals!
 
 Completed Goal:
 Yay! After (#) weeks, I have managed to save ___% of my goal, (__________________)! Thanks everyone for your support! :D
 
 */

-(void)getDataFromSetting
{
    //Get setting bundle data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Facebook = [defaults boolForKey:@"FacebookSwitch"];
    Twitter = [defaults boolForKey:@"TwitterSwitch"];
    Share = [defaults boolForKey:@"ShareSwitch"];
}

//How to use both together

/*
 
//Get setting data from setting bundle
SettingsData *s = [[SettingsData alloc]init];

[s getDataFromSetting];
NSLog(s.Facebook ? @"True" : @"False");
NSLog(s.Twitter ? @"True" : @"False");
NSLog(s.Share ? @"True" : @"False");

checkFB = s.Facebook;
checkShare = s.Share;
checkTwitter = s.Twitter;

//First call the FacebookPost method then twitter 
//As the twitter method seem to cause an error for the facebook method if called first
[self FacebookPost];

//There must not be any modal/push after the method call of the method or before the method is being called.
//[self dismissModalViewControllerAnimated:YES];

//References for Twitter
-(void)Tweet
{
	if([SLComposeViewController  isAvailableForServiceType:SLServiceTypeTwitter] && checkTwitter == TRUE)
	{
		SLComposeViewController *twitter = [[SLComposeViewController alloc]init];
		
		twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
		[twitter setInitialText:[NSString stringWithFormat:@"Testing!"]];
        
		[self presentViewController:twitter animated:YES completion:nil];
        
		[twitter setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             NSString *output;
             
             switch (result) {
                 case SLComposeViewControllerResultCancelled:
                     output = @"Action Cancelled";
                     break;
                 case SLComposeViewControllerResultDone:
                     output = @"Tweeted";;
                     break;
                 default:
                     break;
             }
             
             if([output isEqualToString:@"Tweeted"])
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"You have just tweeted on Twitter!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 
                 [alert show];
             }
             
             [self dismissModalViewControllerAnimated:YES];
         }];
	}
    
    
}

//Reference for Facebook
-(void)FacebookPost
{
	if([SLComposeViewController  isAvailableForServiceType:SLServiceTypeFacebook] && checkFB == TRUE)
	{
		SLComposeViewController *facebook = [[SLComposeViewController alloc]init];
		
		facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
		[facebook setInitialText:[NSString stringWithFormat:@"Testing!"]];
        
		[self presentViewController:facebook animated:YES completion:nil];
        
		[facebook setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             NSString *output;
             
             switch (result) {
                 case SLComposeViewControllerResultCancelled:
                     output = @"Action Cancelled";
                     break;
                 case SLComposeViewControllerResultDone:
                     output = @"Posted";
                     break;
                 default:
                     break;
             }
             
             if([output isEqualToString:@"Posted"])
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"You have just posted on Facebook!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 
                 [alert show];
             }
             
             [self Tweet];
         }];
	}
    
}

*/


@end

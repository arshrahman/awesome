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

-(void)getDataFromSetting
{
    //Get data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Facebook = [defaults boolForKey:@"FacebookSwitch"];
    Twitter = [defaults boolForKey:@"TwitterSwitch"];
    Share = [defaults boolForKey:@"ShareSwitch"];
}

-(void)setData :(BOOL)setFacebook :(BOOL)setTwitter : (BOOL)setShare
{
    //Get data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults boolForKey:@"FacebookSwitch"] = setFacebook;
    //[defaults boolForKey:@"TwitterSwitch"] = setTwitter;
    //[defaults boolForKey:@"ShareSwitch"] = setShare;
}

-(void)Tweet
{
	if([SLComposeViewController  isAvailableForServiceType:SLServiceTypeTwitter])
	{
		SLComposeViewController *twitter = [[SLComposeViewController alloc]init];
		
		twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
		[twitter setInitialText:[NSString stringWithFormat:@"Sending a Tweet via iOS Simulator!"]];
        
		//[self presentViewController:twitter animated:YES completion:nil];
        
		[twitter setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             NSString *output;
             
             switch (result) {
                 case SLComposeViewControllerResultCancelled:
                     output = @"Action Cancelled";
                     break;
                 case SLComposeViewControllerResultDone:
                     output = @"Tweetted";
                     break;
                 default:
                     break;
             }
             
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Tweeted" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
             
             [alert show];
         }];
	}
}

-(void)FacebookPost
{
    //Check for NSUserDefault
    
	if([SLComposeViewController  isAvailableForServiceType:SLServiceTypeFacebook])
	{
		SLComposeViewController *facebook = [[SLComposeViewController alloc]init];
		
		facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
		[facebook setInitialText:[NSString stringWithFormat:@"Posting on Facebook via iOS Simulator!"]];
        
		//[self presentViewController:facebook animated:YES completion:nil];
        
		[facebook setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             NSString *output;
             
             switch (result) {
                 case SLComposeViewControllerResultCancelled:
                     output = @"Action Cancelled";
                     break;
                 case SLComposeViewControllerResultDone:
                     output = @"Tweetted";
                     break;
                 default:
                     break;
             }
             
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Posted" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
             
             [alert show];
         }];
	}
}


@end

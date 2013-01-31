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

@end

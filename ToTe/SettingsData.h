//
//  SettingsData.h
//  ToTe
//
//  Created by user on 31/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface SettingsData : NSObject

@property BOOL Facebook;
@property BOOL Twitter;
@property BOOL Share;

-(void)getDataFromSetting;

@end

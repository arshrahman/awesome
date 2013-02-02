//
//  StartPageViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 8/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "StartPageViewController.h"
#import "Database.h"

@interface StartPageViewController ()

@end

@implementation StartPageViewController
{
    NSString *pListPath;
}

@synthesize lblTip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self readAppPlist];
    
    time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(navigatePage) userInfo:nil repeats:NO];
    
}


- (void) navigatePage
{
    UITabBarController *tabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTab"];
    [self.navigationController pushViewController:tabBar animated:YES];    
}


-(void)readAppPlist
{
    pListPath = [[NSBundle mainBundle] pathForResource:@"TipOfDay" ofType:@"plist"];
    NSMutableDictionary * propertyDict = [[NSMutableDictionary alloc] initWithContentsOfFile:pListPath];
    
    int randomNum = arc4random() % 33;
    if (randomNum == 0)randomNum = 1;
    
    lblTip.text = [propertyDict objectForKey:[NSString stringWithFormat:@"%d", randomNum]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {

    [self setLblTip:nil];
    [super viewDidUnload];
}

@end

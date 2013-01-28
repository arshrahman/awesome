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
    
    time = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(navigatePage) userInfo:nil repeats:NO];
    
}


- (void) navigatePage
{
    UITabBarController *tabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTab"];
    [self.navigationController pushViewController:tabBar animated:YES];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {

    [super viewDidUnload];
}

@end

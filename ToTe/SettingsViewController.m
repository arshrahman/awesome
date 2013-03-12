//
//  SettingsViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 24/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "SettingsViewController.h"
#import "BudgetViewController.h"
#import "setBudgetViewController.h"

@interface SettingsViewController ()
{
    int FirstTimeUse;
}

@end

@implementation SettingsViewController

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
    
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *ns = [[NSUserDefaults standardUserDefaults]objectForKey:@"FirstTimeUser"];
    FirstTimeUse = [ns intValue];
    
    if (FirstTimeUse != 3)
    {
        //Message box
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sharing Of Data"message:@"For your information, this application gather data and is being shared with Temeask Polytechic for research purposes. To disable this function, look under phone setting." delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
        
        BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
        [self.navigationController pushViewController:svc animated:NO];
        
    }
    else
    {
        //Not first use
        setBudgetViewController *sbc = [self.storyboard instantiateViewControllerWithIdentifier:@"setBudgetViewController"];
        [self.navigationController pushViewController:sbc animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

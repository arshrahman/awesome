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
    
    NSString *ns = [[NSUserDefaults standardUserDefaults]objectForKey:@"FirstTimeUser"];
    int FirstTimeUse = [ns intValue];
    
    if (FirstTimeUse != 3)
    {
        BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
        [self.navigationController pushViewController:svc animated:YES];
        
    }
    else
    {
        setBudgetViewController *sbc = [self.storyboard instantiateViewControllerWithIdentifier:@"setBudgetViewController"];
        [self.navigationController pushViewController:sbc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
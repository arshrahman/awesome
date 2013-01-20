//
//  setBudgetViewController.m
//  ToTe
//
//  Created by user on 3/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "setBudgetViewController.h"
#import "Database.h"
#import "BudgetViewController.h"

@interface setBudgetViewController ()

@end

@implementation setBudgetViewController
{
    //Database *d;
}

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
    NSLog(@"user: %d", FirstTimeUse);
    if (FirstTimeUse == 2)
    {
        BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
        [self.navigationController pushViewController:svc animated:YES];

    }
    /*else
    {
        BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
        [self.navigationController pushViewController:svc animated:YES];
    }*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

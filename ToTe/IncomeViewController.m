//
//  IncomeViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 10/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IncomeViewController.h"
#import "Database.h"
#import "BudgetViewController.h"

@interface IncomeViewController ()

@end

@implementation IncomeViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [super viewDidUnload];
}
- (IBAction)btndone:(id)sender
{
    NSString *stincome = self.txtincome.text;
    int wincome = [stincome intValue];
    
    Database *d = [[Database alloc]init];
    if ([d InsertWeeklyIncome:wincome])
    {
        BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[self txtincome]resignFirstResponder];
}




@end

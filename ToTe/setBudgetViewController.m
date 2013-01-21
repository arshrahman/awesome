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
    NSMutableArray *topArray;
}

@synthesize topView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *ns = [[NSUserDefaults standardUserDefaults]objectForKey:@"FirstTimeUser"];
    int FirstTimeUse = [ns intValue];
    NSLog(@"user: %d", FirstTimeUse);
    
    if (FirstTimeUse != 3)
    {
        BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
        [self.navigationController pushViewController:svc animated:YES];

    }    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return topArray.count + 2;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Income: $80";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

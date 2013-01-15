//
//  BudgetViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 13/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "BudgetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BudgetViewController ()

@end

@implementation BudgetViewController

@synthesize budgetCat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //data = [[NSArray alloc]initWithObjects:@"1", @"2", @"3", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController setDelegate:self];
    self.navigationItem.hidesBackButton = YES;
    data = [[NSArray alloc]initWithObjects:@"Add Category", @"Food", @"Transport", @"Utility", nil];
    budgetCat.layer.cornerRadius = 5.0f;
    budgetCat.layer.borderColor = [UIColor lightGrayColor].CGColor;
    budgetCat.layer.borderWidth = 1;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //if (userHasCompletedAction) {
        return YES;
    //}
    //return NO;
}


- (NSInteger)numberOfSelectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    

    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        txtCatValue = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 185, 30)];
        txtCatValue.tag = 100;
        [txtCatValue addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:txtCatValue];
    }
    else
    {
        txtCatValue = (UITextField *)[cell.contentView viewWithTag:100];
        //[cell.contentView bringSubviewToFront:txtCatValue];
    }
    
    cell.textLabel.text = [data objectAtIndex:indexPath.row];

    return cell;
}

- (void)ValueChanged:(UITextField *)sender
{
    UITableViewCell *ParentCell = [[sender superview] superview];
    NSIndexPath *ipOftxtfield = [budgetCat indexPathForCell:ParentCell];
    NSLog(@"index path: %d", ipOftxtfield.row);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //[cell setBackgroundColor:[UIColor lightGrayColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.textLabel.textColor = [UIColor grayColor];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Categories" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Clothes", @"Books", @"Saloon", @"Snacks", @"Charity", @"Parents",@"School", nil];
        
        [as showFromTabBar:self.tabBarController.tabBar];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[self txtBudget]resignFirstResponder];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtBudget:nil];
    [self setBudgetCat:nil];
    lblBudget = nil;
    [super viewDidUnload];
}


@end

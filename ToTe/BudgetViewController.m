
//
//  BudgetViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 13/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "BudgetViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface BudgetViewController ()
{
    int budgetValue;
    //Temporary
    NSMutableArray *data;
    NSMutableArray *otherButtons;
}

@end

@implementation BudgetViewController

@synthesize budgetCat;
@synthesize scrollView;

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
    [self.tabBarController setDelegate:self];
    self.navigationItem.hidesBackButton = YES;
    data = [[NSMutableArray alloc]init];
    otherButtons = [[NSMutableArray alloc]initWithObjects:@"Clothes", @"Books", @"Saloon", @"Snacks", @"Charity", @"Parents",@"School", nil];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + [data count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    static NSString *cellStaticID = @"cellStatic";
    
    if (indexPath.row == 0)
    {
        UITableViewCell *staticCell = [tableView dequeueReusableCellWithIdentifier:cellStaticID];
        UIImageView *img = nil;
        UILabel *lblstatic = nil;
        
        if (!staticCell)
        {
            staticCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStaticID];
            
            img = [[UIImageView alloc]initWithFrame:CGRectMake(7,7, 25, 25)];
            img.image=[UIImage imageNamed:@"glyphicons_190_circle_plus.png"];
            
            lblstatic = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 180, 30)];
            lblstatic.textColor = [UIColor grayColor];
            lblstatic.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblstatic.text = @"Add Category";
            
            [staticCell.contentView addSubview:img];
            [staticCell.contentView addSubview:lblstatic];
        }
        
        //staticCell.textLabel.text = @"Add Category";
        
        return staticCell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        UITextField *txtCatValue = nil;
        UILabel *lblCat = nil;
        UIImageView *imv = nil;
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            txtCatValue = [[UITextField alloc]initWithFrame:CGRectMake(170, 10, 185, 30)];
            txtCatValue.font = [UIFont fontWithName:@"Helvetica" size:14];
            txtCatValue.tag = 100;
            txtCatValue.placeholder = @"Enter Amount";
            txtCatValue.textColor = [UIColor blackColor];
            txtCatValue.keyboardType = UIKeyboardTypeNumberPad;
            txtCatValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [txtCatValue addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [txtCatValue addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            [txtCatValue addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEnd];
            
            
            lblCat = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 130, 30)];
            lblCat.textColor = [UIColor blackColor];
            lblCat.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblCat.tag = 200;
            
            imv = [[UIImageView alloc]initWithFrame:CGRectMake(7,7, 25, 25)];
            imv.image=[UIImage imageNamed:@"glyphicons_069_gift.png"];
            imv.tag = 300;
            
            [cell.contentView addSubview:txtCatValue];
            [cell.contentView addSubview:lblCat];
            [cell.contentView addSubview:imv];
        }
        else
        {
            lblCat = (UILabel *)[cell.contentView viewWithTag:200];
            txtCatValue = (UITextField *)[cell.contentView viewWithTag:100];
            imv = (UIImageView *)[cell.contentView viewWithTag:300];
        }
        
        lblCat.text = [data objectAtIndex:indexPath.row-1];
        
        return cell;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView adjustOffsetToIdealIfNeeded];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    budgetValue += [textField.text intValue];
    lblBudget.text =  [NSString stringWithFormat:@"$%d",budgetValue];
}

-(void)textFieldDoneEditing:(UITextField *)textField
{
    //budgetValue += [textField.text intValue];
    //lblBudget.text =  [NSString stringWithFormat:@"$%d",budgetValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Categories" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (int i=0; i < [otherButtons count]; i++)
        {
            NSString *button = [otherButtons objectAtIndex:i];
            [as addButtonWithTitle:button];
        }
        
        [as showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /*Person *p = [arrayOfPerson objectAtIndex:indexPath.row];
         [self deleteData:[NSString stringWithFormat:@"DELETE FROM PERSONS WHERE NAME IS '%s'", [p.name UTF8String]]];*/
        [data removeObjectAtIndex:indexPath.row-1];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [data addObject:[otherButtons objectAtIndex:buttonIndex]];
    [[self budgetCat]reloadData];
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
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end











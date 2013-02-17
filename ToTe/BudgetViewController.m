
//
//  BudgetViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 13/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "BudgetViewController.h"
#import "setBudgetViewController.h"
#import "Category.h"
#import "BudgetCategory.h"
#import "Budget.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface BudgetViewController ()
{
    double budgetValue;
    NSMutableArray *bgCat;
    NSMutableArray *otherButtons;
}

@end

@implementation BudgetViewController

@synthesize budgetCat;
@synthesize scrollView;
@synthesize txtBudget;
@synthesize tbWeeklyIncome;

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
    bgCat = [[NSMutableArray alloc]init];
    Category *c = [[Category alloc]init];
    otherButtons = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        [otherButtons addObject:cc];
    }
    
    budgetCat.layer.cornerRadius = 5.0f;
    budgetCat.layer.borderColor = [UIColor lightGrayColor].CGColor;
    budgetCat.layer.borderWidth = 1;
    
    tbWeeklyIncome.layer.cornerRadius = 5.0f;
    tbWeeklyIncome.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tbWeeklyIncome.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tap];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    return 1 + [bgCat count];
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
            staticCell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            img = [[UIImageView alloc]initWithFrame:CGRectMake(7,7, 25, 25)];
            img.image=[UIImage imageNamed:@"glyphicons_190_circle_plus.png"];
            
            lblstatic = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 160, 30)];
            lblstatic.textColor = [UIColor grayColor];
            lblstatic.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblstatic.text = @"Add Category";
            
            [staticCell.contentView addSubview:img];
            [staticCell.contentView addSubview:lblstatic];
        }
        
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
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            txtCatValue = [[UITextField alloc]initWithFrame:CGRectMake(170, 10, 165, 30)];
            txtCatValue.font = [UIFont fontWithName:@"Helvetica" size:14];
            txtCatValue.tag = 100;
            txtCatValue.placeholder = @"Enter Amount";
            txtCatValue.textColor = [UIColor blackColor];
            txtCatValue.keyboardType = UIKeyboardTypeDecimalPad;
            txtCatValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [txtCatValue addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [txtCatValue addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            lblCat = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 130, 30)];
            lblCat.textColor = [UIColor blackColor];
            lblCat.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblCat.tag = 200;
            
            imv = [[UIImageView alloc]initWithFrame:CGRectMake(7,7, 25, 25)];
            //imv.image=[UIImage imageNamed:@"glyphicons_069_gift.png"];
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
        
        BudgetCategory *bgc = [bgCat objectAtIndex:indexPath.row-1];
        
        lblCat.text = bgc.bcategory_name;
        imv.image = [UIImage imageNamed:bgc.bcategory_image];
        if (bgc.category_amount > 0)
        {
            txtCatValue.text = [NSString stringWithFormat:@"%g", bgc.category_amount];
        }
        else txtCatValue.text = @"";
        
        return cell;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView adjustOffsetToIdealIfNeeded];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    //UITableViewCell *selectedCell = (UITableViewCell *)textField.superview.superview;
    //NSIndexPath *indexPath = [self.budgetCat indexPathForCell:selectedCell];
    //NSIndexPath *indexPath = [self.budgetCat indexPathForCell:(UITableViewCell *)[(UIView *)[textField superview] superview]];
    
    CGRect textFieldFrame = [textField convertRect:textField.bounds toView:self.budgetCat];
    NSIndexPath *indexPath = [self.budgetCat indexPathForRowAtPoint:textFieldFrame.origin];
    
    BudgetCategory *bgc = [bgCat objectAtIndex:indexPath.row-1];
    budgetValue -= bgc.category_amount;
    bgc.category_amount = [textField.text doubleValue];
    budgetValue += bgc.category_amount;
    
    lblBudget.text =  [NSString stringWithFormat:@"$%.2f",budgetValue];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Categories" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                
        for(Category *c in otherButtons)
        {
            [as addButtonWithTitle:c.category_name];
        }
        
        [as addButtonWithTitle:@"Cancel"];
        as.cancelButtonIndex = as.numberOfButtons-1;
        
        [as showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            BudgetCategory *bgc = [bgCat objectAtIndex:indexPath.row-1];
            
            Category *c = [[Category alloc]init];
            c.category_id = bgc.category_id;
            c.category_image = bgc.bcategory_image;
            c.category_name = bgc.bcategory_name;
            
            budgetValue -= bgc.category_amount;
            
            [bgCat removeObjectAtIndex:indexPath.row-1];
            [otherButtons addObject:c];
            lblBudget.text =  [NSString stringWithFormat:@"$%.2f",budgetValue];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }

    }
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        Category *c = [otherButtons objectAtIndex:buttonIndex];
        BudgetCategory *bc = [[BudgetCategory alloc]init];
        bc.category_id = c.category_id;
        bc.bcategory_name = c.category_name;
        bc.bcategory_image = c.category_image;
        
        [bgCat addObject:bc];
        [otherButtons removeObject:c];
        [[self budgetCat]reloadData];
    }
}

-(IBAction)btnDone:(id)sender
{    
    bool showAlert = false;

    if (txtBudget.text.length > 0 && bgCat.count > 0)
    {
        double wkIncome = [txtBudget.text doubleValue];
        
        if (wkIncome > budgetValue)
        {
            for (BudgetCategory *bc in bgCat)
            {
                if (bc.category_amount == 0)
                {
                    showAlert = true;
                }
            }
            
            if (showAlert == true)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Budget"message:@"Please specify the amount for your categories!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                Budget *b = [[Budget alloc]init];
                [b InsertBudget:budgetValue:wkIncome];
                [b InsertBudgetCategories:bgCat];
                
                setBudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"setBudgetViewController"];
                [self.navigationController pushViewController:svc animated:YES];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Budget"message:@"Weekly income must be greater than your budget!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Budget"message:@"Please enter your weekly income and categories!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];

    }
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
    [self setTbWeeklyIncome:nil];
    [super viewDidUnload];
}

@end











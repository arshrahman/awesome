//
//  viewPurchasesViewController.m
//  ToTe
//
//  Created by user on 14/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "viewPurchasesViewController.h"
#import "Database.h"
#import "Purchase.h"
#import "Category.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface viewPurchasesViewController ()
{
    NSMutableArray *plist;
    int budgetValue;
    //Temporary
    NSMutableArray *data;
    NSMutableArray *otherButtons;
    NSString *CheckCate;
}

@end

@implementation viewPurchasesViewController

@synthesize purchaseTV;
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
    Category *c = [[Category alloc]init];
    otherButtons = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        //NSLog(@"Category: %d, %@, %@", cc.category_id, cc.category_name, cc.category_image);
        [otherButtons addObject:cc];
    }
    
    purchaseTV.layer.cornerRadius = 5.0f;
    purchaseTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    purchaseTV.layer.borderWidth = 1;
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
            lblstatic.text = @"Add New Purchase";
            
            [staticCell.contentView addSubview:img];
            [staticCell.contentView addSubview:lblstatic];
        }
        
        //staticCell.textLabel.text = @"Add Category";
        
        return staticCell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        //UITextField *txtCatValue = nil;
        UILabel *lblCat = nil;
        //Button to trigger action sheet and select category
        UIButton *btnCate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //UIImageView *imv = nil;
        
        UITextField *txtNameValue = nil;
        UILabel *lblName = nil;
        
        UITextField *txtPriceValue = nil;
        UILabel *lblPrice = nil;
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            //Purchase Item Category
            txtNameValue = [[UITextField alloc]initWithFrame:CGRectMake(140, 2, 65, 20)];
            txtNameValue.font = [UIFont fontWithName:@"Helvetica" size:16];
            txtNameValue.tag = 100;
            txtNameValue.placeholder = @"Item Name";
            txtNameValue.textColor = [UIColor blackColor];
            txtNameValue.keyboardType = UIKeyboardTypeAlphabet;
            txtNameValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [txtNameValue addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [txtNameValue addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            [txtNameValue addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEnd];
            
            /*
            lblName = [[UILabel alloc]initWithFrame:CGRectMake(140, 2, 90, 20)];
            lblName.textColor = [UIColor blackColor];
            lblName.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblName.text = @"Item Name: ";
            lblName.tag = 200;
             */
            
            //imv = [[UIImageView alloc]initWithFrame:CGRectMake(7,7, 25, 25)];
            //imv.tag = 300;
            
            [cell.contentView addSubview:txtNameValue];
            //[cell.contentView addSubview:lblName];
            //[cell.contentView addSubview:imv];
            
            //Done
            //Purchase Item Price
            txtPriceValue = [[UITextField alloc]initWithFrame:CGRectMake(10, 23, 60, 20)];
            txtPriceValue.font = [UIFont fontWithName:@"Helvetica" size:12];
            txtPriceValue.tag = 400;
            txtPriceValue.placeholder = @"Enter Item Amount";
            txtPriceValue.textColor = [UIColor blackColor];
            txtPriceValue.keyboardType = UIKeyboardTypeNumberPad;
            txtPriceValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [txtPriceValue addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [txtPriceValue addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            [txtPriceValue addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEnd];
            
            /*
            lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 65, 20)];
            lblPrice.textColor = [UIColor blackColor];
            lblPrice.font = [UIFont fontWithName:@"Helvetica" size:12];
            lblPrice.text = @"Item Price: ";
            lblPrice.tag = 500;
             */
            
            [cell.contentView addSubview:txtPriceValue];
            //[cell.contentView addSubview:lblPrice];
            
            //Done
            //Purchase Item Name
            //txtNameValue = [[UITextField alloc]initWithFrame:CGRectMake(100, 2, 80, 20)];
            //txtNameValue.font = [UIFont fontWithName:@"Helvetica" size:16];
            //txtNameValue.tag = 600;
            //txtNameValue.placeholder = @"-Name-";
            //txtNameValue.textColor = [UIColor blackColor];
            //txtNameValue.keyboardType = UIKeyboardTypeNumberPad;
            //txtNameValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            //[txtNameValue addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            //[txtNameValue addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            //[txtNameValue addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEnd];
            
            [btnCate addTarget:self action:@selector(SelectCat:) forControlEvents:UIControlEventTouchUpInside];
            [btnCate setTitle:@"Select Category" forState:UIControlStateNormal];
            btnCate.frame = CGRectMake(10.0, 2.0, 120.0, 23.0);
            btnCate.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
            btnCate.tag = 700;
            [cell.contentView addSubview:btnCate];
            
            //lblCat = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 90, 20)];
            //lblCat.textColor = [UIColor blackColor];
            //lblCat.font = [UIFont fontWithName:@"Helvetica" size:16];
            //lblCat.text = @"Item Name: ";
            //lblCat.tag = 700;
            
            //[cell.contentView addSubview:txtNameValue];
            //[cell.contentView addSubview:lblCat];
        }
        else
        {
            btnCate = (UIButton *)[cell.contentView viewWithTag:700];
            //lblCat = (UILabel *)[cell.contentView viewWithTag:700];
            lblPrice = (UILabel *)[cell.contentView viewWithTag:500];
            lblName = (UILabel *)[cell.contentView viewWithTag:200];
            txtNameValue = (UITextField *)[cell.contentView viewWithTag:100];
            txtPriceValue = (UITextField *)[cell.contentView viewWithTag:400];
            //txtCatValue = (UITextField *)[cell.contentView viewWithTag:100];
            //imv = (UIImageView *)[cell.contentView viewWithTag:300];
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
    //budgetValue += [textField.text intValue];
    //lblBudget.text =  [NSString stringWithFormat:@"$%d",budgetValue];
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Add New Purchase" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add New Purchase", nil];
        actionSheet.tag = 1;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)SelectCat:(id)sender {
    NSLog(@"Trigger Select Category! WooHoo!");
    
    UIActionSheet *actionSheet2 = [[UIActionSheet alloc]initWithTitle:@"Categories" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    actionSheet2.tag = 2;
    
    for(Category *c in otherButtons)
    {
        [actionSheet2 addButtonWithTitle:c.category_name];
    }
    
    [actionSheet2 showFromTabBar:self.tabBarController.tabBar];
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
    if(actionSheet.tag == 1)
    {
        //Purchase *p = [otherButtons objectAtIndex:buttonIndex];
        Category *c = [otherButtons objectAtIndex:buttonIndex];
        //Add Purchase
        if(buttonIndex==1)
        {
            NSString *check = [NSString stringWithFormat:@"%d", buttonIndex];
            NSLog(check);
        }
        else if(buttonIndex==0)
        {
            NSString *check = [NSString stringWithFormat:@"%d", buttonIndex];
            NSLog(check);
            Category *c = [otherButtons objectAtIndex:buttonIndex];
            [data addObject:c.category_name];
        }
        else
        {
            NSLog(@"Error!");
        }

    }
    else if(actionSheet.tag = 2)
    {
        //Select a Catergory
        Category *c = [otherButtons objectAtIndex:buttonIndex];
        CheckCate = c.category_name;
        NSLog(CheckCate);
        
        
    }
    
    //Temporily
    [[self purchaseTV]reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPurchaseTV:nil];
    lblBudget = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end











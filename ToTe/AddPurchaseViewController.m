//
//  AddPurchaseViewController.m
//  ToTe
//
//  Created by user on 20/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "AddPurchaseViewController.h"
#import "Purchase.h"
#import "PurchaseViewController.h"
#import "Category.h"

@interface AddPurchaseViewController ()
{
    NSMutableArray *CategoryList;
    
}

@end

@implementation AddPurchaseViewController

@synthesize AddItemName = _AddItemName;
@synthesize AddItemPrice = _AddItemPrice;
@synthesize AddItemCategory = _AddItemCategory;
@synthesize purchaseViewController = _purchaseViewController;
@synthesize AddStar1;
@synthesize AddStar2;
@synthesize AddStar3;
@synthesize AddStar4;
@synthesize AddStar5;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    Category *c = [[Category alloc]init];
    CategoryList = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        [CategoryList addObject:cc];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAddItemName:nil];
    [self setAddItemPrice:nil];
    [self setAddItemCategory:nil];
    [self setAddStar1:nil];
    [self setAddStar2:nil];
    [self setAddStar3:nil];
    [self setAddStar4:nil];
    [self setAddStar5:nil];
    [super viewDidUnload];
}

- (IBAction)SelectCategory:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Categories" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    //Change the index
    for(Category *c in CategoryList)
    {
        [as addButtonWithTitle:c.category_name];
    }
    
    as.cancelButtonIndex = [as addButtonWithTitle:@"Cancel"];
    
    [as showInView:self.view];
    //[as showFromTabBar:self.tabBarController.tabBar];
}

-(void)cancelPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)donePressed:(id)sender{
    
    Purchase *newPurchase = [[Purchase alloc] init];
    //NSLog([NSString stringWithFormat: @"%d", self.purchaseItem.uniqueId]);
    
    //NSString *name = self.EditItemName.text;
    NSString *price = self.AddItemPrice.text;
    NSString *category = self.AddItemCategory.currentTitle;
    if(([price length] == 0 || [price doubleValue] == 0) && [category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Purchase"message:@"Please specify the amount of the item and the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([price length] == 0 || [price doubleValue] == 0)
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Purchase"message:@"Please specify the amount of the item in the textfield!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Purchase"message:@"Please specify the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Add to database
        if([self.AddItemName.text length] == 0)
        {
            newPurchase.name = self.AddItemCategory.currentTitle;
        }
        else
        {
            newPurchase.name = self.AddItemName.text;
        }
        
        newPurchase.price = [self.AddItemPrice.text doubleValue];
        newPurchase.category = self.AddItemCategory.currentTitle;
        newPurchase.priority = AddStar;
        
        [self.purchaseViewController.PurchaseList addObject:newPurchase];
        //[self.purchaseViewController.PurchaseTableView reloadData];
        
        //add into database
        [newPurchase addPurchase:newPurchase.price: newPurchase.category : newPurchase.name : newPurchase.priority];
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)textfieldReutrn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *check2 = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSLog(check2);
    
    if([check2 isEqualToString:@"Cancel"])
    {
     [self.AddItemCategory setTitle:@"Select Category" forState:UIControlStateNormal];   
    }
    else
    {
        Category *c = [CategoryList objectAtIndex:buttonIndex];
        [self.AddItemCategory setTitle:c.category_name forState:UIControlStateNormal];
    }
}

-(IBAction)starOneClicked:(id)sender
{
    NSLog(@"Checking Star One");
    if(AddStar == 1)
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        AddStar = 0;
    }
    else
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        AddStar = 1;
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starTwoClicked:(id)sender
{
    NSLog(@"Checking Star Two");
    if(AddStar == 2)
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        AddStar = 1;
        
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
    
    else
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
    
        AddStar = 2;
    
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starThreeClicked:(id)sender
{
    NSLog(@"Checking Star Three");
    if(AddStar == 3)
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        AddStar = 2;
        
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];

    }
    else
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
    
        AddStar = 3;
    
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starFourClicked:(id)sender
{
    NSLog(@"Checking Star Four");
    if(AddStar == 4)
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        AddStar = 3;
        
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
    else
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        AddStar = 4;
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starFiveClicked:(id)sender
{
    NSLog(@"Checking Star Five");
    if(AddStar == 5)
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        AddStar = 4;
        
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
    else
    {
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        AddStar = 5;
    }
}

@end

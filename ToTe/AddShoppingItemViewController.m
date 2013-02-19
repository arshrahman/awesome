//
//  AddShoppingItemViewController.m
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "AddShoppingItemViewController.h"
#import "EditTripViewController.h"
#import "ShoppingTripItem.h"
#import "Category.h"

@interface AddShoppingItemViewController ()
{
    NSMutableArray *CategoryList;
    int catID;
    CMPopTipView *tooltip;
}

@end

@implementation AddShoppingItemViewController

@synthesize AddItemName = _AddItemName;
@synthesize AddItemPrice = _AddItemPrice;
@synthesize AddItemCategory = _AddItemCategory;
@synthesize editTripViewController = _editTripViewController;
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

    NSLog(@"Add Shopping Trip Item");
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
    [self setAddItemCategory:nil];
    [self setAddItemPrice:nil];
    [self setAddItemName:nil];
    [self setAddStar1:nil];
    [self setAddStar2:nil];
    [self setAddStar3:nil];
    [self setAddStar4:nil];
    [self setAddStar5:nil];
    [self setAddNewItem:nil];
    [super viewDidUnload];
}

- (IBAction)DownKeyPad:(id)sender {
   
}

- (IBAction)Cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)textfieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)SelectCategory:(id)sender
{
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

- (IBAction)donePressed:(id)sender {
    
    //Add shopping item into database
    ShoppingTripItem *newItem = [[ShoppingTripItem alloc] init];
    //NSLog([NSString stringWithFormat: @"%d", self.purchaseItem.uniqueId]);
    
    NSString *price = self.AddItemPrice.text;
    NSString *category = self.AddItemCategory.currentTitle;
    if(([price length] == 0 || [price doubleValue] == 0) && [category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Item"message:@"Please specify the price of the item and the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([price length] == 0 || [price doubleValue] == 0)
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Item"message:@"Please specify the price of the item in the textfield!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Item"message:@"Please specify the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Add to database
        if([self.AddItemName.text length] == 0)
        {
            newItem.shoppingItemName = self.AddItemCategory.currentTitle;
        }
        else
        {
            newItem.shoppingItemName = self.AddItemName.text;
        }
        
        newItem.shoppingItemPrice = [self.AddItemPrice.text doubleValue];
        newItem.category = self.AddItemCategory.currentTitle;
        newItem.necessity = AddStar;
        newItem.categoryID = catID;
        
        
        [self.editTripViewController.ShoppingTripItemList addObject:newItem];
        NSLog(@"%d", self.editTripViewController.ShoppingTripItemList.count);
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *check2 = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([check2 isEqualToString:@"Cancel"])
    {
        [self.AddItemCategory setTitle:@"Select Category" forState:UIControlStateNormal];
    }
    else
    {
        Category *c = [CategoryList objectAtIndex:buttonIndex];
        catID = c.category_id;
        [self.AddItemCategory setTitle:c.category_name forState:UIControlStateNormal];
    }
}

-(IBAction)newItem:(id)sender
{
    [self.AddItemPrice resignFirstResponder];
    [self.AddItemName resignFirstResponder];
    
    //Add shopping item into database
    ShoppingTripItem *newItem = [[ShoppingTripItem alloc] init];
    //NSLog([NSString stringWithFormat: @"%d", self.purchaseItem.uniqueId]);
    
    NSString *price = self.AddItemPrice.text;
    NSString *category = self.AddItemCategory.currentTitle;
    if(([price length] == 0 || [price doubleValue] == 0) && [category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Item"message:@"Please specify the price of the item and the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([price length] == 0 || [price doubleValue] == 0)
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Item"message:@"Please specify the price of the item in the textfield!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Item"message:@"Please specify the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Add to database
        if([self.AddItemName.text length] == 0)
        {
            newItem.shoppingItemName = self.AddItemCategory.currentTitle;
        }
        else
        {
            newItem.shoppingItemName = self.AddItemName.text;
        }
        
        newItem.shoppingItemPrice = [self.AddItemPrice.text doubleValue];
        newItem.category = self.AddItemCategory.currentTitle;
        newItem.necessity = AddStar;
        newItem.categoryID = catID;
        
        [self.editTripViewController.ShoppingTripItemList addObject:newItem];
        NSLog(@"%d", self.editTripViewController.ShoppingTripItemList.count);
        
        AddStar = 0;
        [AddStar1 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [AddStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        
        [self.AddItemCategory setTitle:@"Select Category" forState:UIControlStateNormal];
        [self.AddItemPrice setText:@""];
        [self.AddItemName setText:@""];
        
        
        NSString *count = [NSString stringWithFormat: @"Number of item added: %d", self.editTripViewController.ShoppingTripItemList.count];
        
        tooltip = [[CMPopTipView alloc]
                   initWithMessage:count] ;
        tooltip.delegate = self;
        tooltip.backgroundColor = [UIColor grayColor];
        tooltip.textColor = [UIColor whiteColor];
        [tooltip presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
        
        NSTimer *timerShowToolTip;
        timerShowToolTip = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dismissToolTip) userInfo:nil repeats:NO];
    }
}

- (void) dismissToolTip
{
    [tooltip dismissAnimated:YES];
}



@end

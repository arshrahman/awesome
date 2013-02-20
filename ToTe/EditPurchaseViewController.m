//
//  EditPurchaseViewController.m
//  ToTe
//
//  Created by user on 20/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "EditPurchaseViewController.h"
#import "Purchase.h"
#import "Category.h"

@interface EditPurchaseViewController ()
{
    NSMutableArray *CategoryList;
    int catID;
}

@end

@implementation EditPurchaseViewController

@synthesize EditItemName = _EditItemName;
@synthesize EditItemPrice = _EditItemPrice;
@synthesize purchaseItem = _purchaseItem;
@synthesize EditItemCategory = _EditItemCategory;
@synthesize EditStar1;
@synthesize EditStar2;
@synthesize EditStar3;
@synthesize EditStar4;
@synthesize EditStar5;

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
    
    self.EditItemName.text = self.purchaseItem.name;
    self.EditItemPrice.text = [NSString stringWithFormat: @"%.2lf", self.purchaseItem.price];
    [self.EditItemCategory setTitle:self.purchaseItem.category forState:UIControlStateNormal];
    catID = self.purchaseItem.cateID;
    EditStar = self.purchaseItem.priority;
    
    if(EditStar == 5)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
    }
    else if(EditStar == 4)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
    }
    else if(EditStar == 3)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
    }
    else if(EditStar == 2)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
    }
    else if(EditStar == 1)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
    }
    else
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
    
    
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
    [self setEditItemName:nil];
    [self setEditItemPrice:nil];
    [self setEditItemCategory:nil];
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
}

- (IBAction)btnUpdate:(id)sender {
    //Update into database
    
    Purchase *p = [[Purchase alloc]init];
    //NSLog([NSString stringWithFormat: @"%d", self.purchaseItem.uniqueId]);
    
    //NSString *name = self.EditItemName.text;
    NSString *price = self.EditItemPrice.text;
    NSString *category = self.EditItemCategory.currentTitle;
    if(([price length] == 0 || [price doubleValue] == 0) && [category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Purchase"message:@"Please specify the price of the item and the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([price length] == 0 || [price doubleValue] == 0)
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Purchase"message:@"Please specify the price of the item in the textfield!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
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
        self.purchaseItem.name = self.EditItemName.text;
        self.purchaseItem.price = [self.EditItemPrice.text doubleValue];
        self.purchaseItem.category = self.EditItemCategory.currentTitle;
        self.purchaseItem.cateID = catID;
        self.purchaseItem.priority = EditStar;
        
        [p updatePurchase:self.purchaseItem.uniqueId :self.purchaseItem.name :self.purchaseItem.cateID :self.purchaseItem.price :self.purchaseItem.priority];
        [self dismissModalViewControllerAnimated:YES];
    }
    
    NSLog(@"Update data");
    
    [self.view endEditing:YES];
}

-(IBAction)cancelPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)textfieldReutrn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *check2 = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([check2 isEqualToString:@"Cancel"])
    {
        //[self.EditItemCategory setTitle:@"Select Category" forState:UIControlStateNormal];
    }
    else
    {
        Category *c = [CategoryList objectAtIndex:buttonIndex];
        catID = c.category_id;
        [self.EditItemCategory setTitle:c.category_name forState:UIControlStateNormal];
    }
}

-(IBAction)starOneClicked:(id)sender
{
    NSLog(@"Checking Star One");
    if(EditStar == 1)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        EditStar = 0;
    }
    else
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        EditStar = 1;
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starTwoClicked:(id)sender
{
    NSLog(@"Checking Star Two");
    if(EditStar == 2)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 1;
        
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
    
    else
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 2;
        
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starThreeClicked:(id)sender
{
    NSLog(@"Checking Star Three");
    if(EditStar == 3)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 2;
        
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 3;
        
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starFourClicked:(id)sender
{
    NSLog(@"Checking Star Four");
    if(EditStar == 4)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 3;
        
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
    else
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 4;
        
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)starFiveClicked:(id)sender
{
    NSLog(@"Checking Star Five");
    if(EditStar == 5)
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 4;
        
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_048_dislikes.png"] forState:UIControlStateNormal];
    }
    else
    {
        [EditStar1 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar2 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar3 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar4 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        [EditStar5 setImage:[UIImage imageNamed:@"glyphicons_049_star.png"] forState:UIControlStateNormal];
        
        EditStar = 5;
    }
}

@end

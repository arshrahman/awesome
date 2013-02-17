//
//  EditShoppingItemViewController.m
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "EditShoppingItemViewController.h"
#import "Category.h"
#import "ShoppingTripItem.h"

@interface EditShoppingItemViewController ()
{
    NSMutableArray *CategoryList;
    int catID;
}

@end

@implementation EditShoppingItemViewController

@synthesize editCategory;
@synthesize editItemName;
@synthesize editItemPrice;
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

    NSLog(@"Edit shopping Trip Item");
    
    self.editItemName.text = self.shoppingItem.shoppingItemName;
    self.editItemPrice.text = [NSString stringWithFormat: @"%.2lf", self.shoppingItem.shoppingItemPrice];
    [self.editCategory setTitle:self.shoppingItem.category forState:UIControlStateNormal];
    catID = self.shoppingItem.categoryID;
    EditStar = self.shoppingItem.necessity;
    
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

- (IBAction)Cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setEditCategory:nil];
    [self setEditItemPrice:nil];
    [self setEditItemName:nil];
    [super viewDidUnload];
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
        [self.editCategory setTitle:@"Select Category" forState:UIControlStateNormal];
    }
    else
    {
        Category *c = [CategoryList objectAtIndex:buttonIndex];
        catID = c.category_id;
        [self.editCategory setTitle:c.category_name forState:UIControlStateNormal];
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

- (IBAction)btnUpdate:(id)sender {
    //Update into database
    
    ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
    //NSLog([NSString stringWithFormat: @"%d", self.purchaseItem.uniqueId]);
    
    //NSString *name = self.EditItemName.text;
    NSString *price = self.editItemPrice.text;
    NSString *category = self.editCategory.currentTitle;
    if(([price length] == 0 || [price doubleValue] == 0) && [category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shopping Item"message:@"Please specify the price of the item and the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([price length] == 0 || [price doubleValue] == 0)
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shopping Item"message:@"Please specify the price of the item in the textfield!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([category isEqualToString:@"Select Category"])
    {
        NSLog(@"Call alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shopping Item"message:@"Please specify the category of the item!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        self.shoppingItem.shoppingItemName = self.editItemName.text;
        self.shoppingItem.shoppingItemPrice = [self.editItemPrice.text doubleValue];
        self.shoppingItem.category = self.editCategory.currentTitle;
        self.shoppingItem.categoryID = catID;
        self.shoppingItem.necessity = EditStar;
        
        [sti updateShoppingItem:self.shoppingItem.itemID :self.shoppingItem.shoppingItemName :self.shoppingItem.categoryID :self.shoppingItem.shoppingItemPrice :self.shoppingItem.necessity];
        
        [self dismissModalViewControllerAnimated:YES];
    }
    
    NSLog(@"Update data");
    
    [self.view endEditing:YES];
}

@end

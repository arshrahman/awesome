//
//  AddShoppingItemViewController.m
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "AddShoppingItemViewController.h"
#import "Purchase.h"
#import "Category.h"

@interface AddShoppingItemViewController ()
{
    NSMutableArray *CategoryList;
    int catID;
}

@end

@implementation AddShoppingItemViewController

@synthesize AddItemName = _AddItemName;
@synthesize AddItemPrice = _AddItemPrice;
@synthesize AddItemCategory = _AddItemCategory;
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

    NSLog(@"hi rahman");
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
    [self setAddItemCategory:nil];
    [self setAddItemPrice:nil];
    [self setAddItemName:nil];
    [self setAddStar1:nil];
    [self setAddStar2:nil];
    [self setAddStar3:nil];
    [self setAddStar4:nil];
    [self setAddStar5:nil];
    [self setAddItemCategory:nil];
    [self setAddItemPrice:nil];
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
    [self dismissModalViewControllerAnimated:YES];
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




@end

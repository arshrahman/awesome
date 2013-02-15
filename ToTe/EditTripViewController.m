//
//  EditTripViewController.m
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "EditTripViewController.h"
#import "AddShoppingItemViewController.h"
#import "ShoppingTripItem.h"
#import "ShoppingTrip.h"
#import "EditShoppingItemViewController.h"

@interface EditTripViewController ()
{
    ShoppingTripItem *Item;
}
@end

@implementation EditTripViewController

@synthesize ShoppingTripBudget;
@synthesize ShoppingTripDuration;
@synthesize ShoppingTripItemTV;
@synthesize ShoppingTripTitle;
@synthesize ShoppingTripItemList;
@synthesize ShoppingTripList;

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
    
    NSLog(@"Edit Shopping Trip");
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShoppingTripTitle:nil];
    [self setShoppingTripBudget:nil];
    [self setShoppingTripDuration:nil];
    [self setShoppingTripItemTV:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditShoppingItemViewController *editingView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditShoppingItemViewController"];
    
    editingView.ShoppingItem = [self.ShoppingTripItemList objectAtIndex:tableView.indexPathForSelectedRow.row];
    
    [editingView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    // Pass the selected object to the new view controller.
    [self presentModalViewController:editingView animated:YES];
}

- (IBAction)Cancel:(id)sender {
    //remove all items using it's shopping id
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)Done:(id)sender {
    
    //Add shopping Trip
    ShoppingTrip *st = [[ShoppingTrip alloc]init];
    
    //Shopping Trip Name
    st.shoppingTripName = ShoppingTripTitle.text;
    
    //Shopping Trip Budget
    st.shoppingBudget = [ShoppingTripBudget.text doubleValue];

    //Shopping Trip Duration
    //st.Duration;
    
    //Shopping Trip total item price
    double i = 0;
    ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
    for(ShoppingTripItem *item in self.ShoppingTripItemList)
    {
        i = i + item.shoppingItemPrice;
        
        //add item into database
        [sti addshoppingItem:item.shoppingItemName :item.shoppingItemPrice :item.categoryID :item.necessity :item.itemsBought];
    }
    
    st.shoppingTotal = i;
    
    //Current Date
    st.shoppingDate = [NSDate date];
    
    //call database code
    //Add Trip
    
    
    
    [self dismissModalViewControllerAnimated:YES];
}
@end

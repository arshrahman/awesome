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
#import "customCell.h"

@interface EditTripViewController ()

@end

@implementation EditTripViewController

@synthesize ShoppingTripBudget;
@synthesize ShoppingTripDuration;
@synthesize ShoppingTripItemTV;
@synthesize ShoppingTripTitle;
@synthesize ShoppingTripItemList = _ShoppingTripItemList;
@synthesize ShoppingTripList = _ShoppingTripList;

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
    self.ShoppingTripItemList = [[NSMutableArray alloc]init];
    self.ShoppingTripList = [[NSMutableArray alloc]init];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.ShoppingTripItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell ==nil)
    {
        cell = [[customCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ShoppingTripItem *currentItem = [[ShoppingTripItem alloc]init];
    currentItem = [self.ShoppingTripItemList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.customCellItemName.text = currentItem.shoppingItemName;
    cell.customCellItemPrice.text = [NSString stringWithFormat: @"$%.2lf", currentItem.shoppingItemPrice];
    cell.customCellItemCategory.text = currentItem.category;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    //NSLog([NSString stringWithFormat: @"%d", currentPurchaseItem.priority]);
    if(currentItem.necessity == 5)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
    }
    else if(currentItem.necessity == 4)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    else if(currentItem.necessity == 3)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    else if(currentItem.necessity == 2)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    else if(currentItem.necessity == 1)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    else
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    
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
    
    //Add shopping Trip and shopping Trip Item
    ShoppingTrip *st = [[ShoppingTrip alloc]init];
    ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
    
    NSString *checkTripName = self.ShoppingTripTitle.text;
    //NSString checkTripDuration = self.ShoppingTripDuration.text;
    NSString *checkTripBudget = self.ShoppingTripBudget.text;
    
    if([checkTripName length] == 0 || [checkTripBudget doubleValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the Trip Name and the Budget for the Trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Shopping Trip Name
        st.shoppingTripName = ShoppingTripTitle.text;
    
        //Shopping Trip Budget
        st.shoppingBudget = [ShoppingTripBudget.text doubleValue];

        //Shopping Trip Duration
        st.Duration = @"00:00";
    
        //Shopping Trip total item price
        double i = 0;
        for(ShoppingTripItem *item in self.ShoppingTripItemList)
        {
            i = i + item.shoppingItemPrice;
        }
    
        st.shoppingTotal = i;
    
        //Current Date
        st.shoppingDate = [NSDate date];
    
        //call database code
        //Add Trip
        [st addshoppingTrip:st.shoppingTripName :st.shoppingBudget :st.Duration :st.shoppingTotal];
        
        NSLog(@"WENT IN TO THE LOOP");
        NSLog(@"%d", self.ShoppingTripItemList.count);
        for(ShoppingTripItem *item in self.ShoppingTripItemList)
        {
            //add item into database
            [sti addshoppingItem:item.shoppingItemName :item.shoppingItemPrice :item.categoryID :item.necessity];
        }
    }
    
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddShoppingItem"]){
        NSLog(@"push to editTripViewController");
        UINavigationController *nav = segue.destinationViewController;
        
        AddShoppingItemViewController *add = [nav.viewControllers objectAtIndex:0];
        add.editTripViewController = self;
    }
    
    //else if([segue.identifier isEqualToString:@"EditItem"])
    //{
    //NSLog(@"push to EditPurchaseViewController");
    //edit.purchaseItem = self;
    //EditPurchaseViewController *editPuchase = segue.destinationViewController;
    
    //editPuchase.purchaseItem = [self.PurchaseList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    //EditPurchaseViewController *editPuchase = segue.destinationViewController;
    //editPuchase.purchaseItem = [self.PurchaseList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    //}
    //NSLog(segue.identifier);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.ShoppingTripItemTV reloadData];
}

@end

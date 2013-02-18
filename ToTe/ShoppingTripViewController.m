//
//  ShoppingTripViewController.m
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ShoppingTripViewController.h"
#import "customCell.h"
#import "ShoppingTrip.h"
#import "ShoppingTripItem.h"
#import "EditShoppingItemViewController.h"

@interface ShoppingTripViewController ()
{
    ShoppingTrip *st;
    ShoppingTripItem *shoppingItem;
}

@end

@implementation ShoppingTripViewController

@synthesize ShoppingTripItemList;
@synthesize ShoppingTripList;
@synthesize ShoppingTripTV;
@synthesize AddTrip;
@synthesize StartEndTrip;
@synthesize lbBudget;
@synthesize lbDuration;
@synthesize lbTripName;

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
    
    NSLog(@"Shopping Trip");
	// Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Retrieve Data
    st = [[ShoppingTrip alloc]init];
    ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
    
    st = [st checkShoppingTrip];
    self.ShoppingTripItemList = [sti viewCurrentShoppingTrip:st.shoppingID];
    
    [self.ShoppingTripTV reloadData];
    
    NSLog(@"%d",self.ShoppingTripItemList.count);
    
    if(st.shoppingID != 0)
    {
        self.lbDuration.text = st.Duration;
        self.lbBudget.text = [NSString stringWithFormat: @"$%.2lf", st.shoppingBudget];
        self.lbTripName.text = st.shoppingTripName;
    }
    
    if(self.ShoppingTripItemList.count > 0)
    {
        self.StartEndTrip.hidden = FALSE;
        //Not Started - 0
        //Progressing - 1
        //Completed - 2
        if(st.shoppingTripCompleted == 0)
        {
            [self.StartEndTrip setTitle:@"Start Trip" forState:UIControlStateNormal];
        }
        else if(st.shoppingTripCompleted == 1)
        {
            [self.StartEndTrip setTitle:@"End Trip" forState:UIControlStateNormal];
        }
    }
    else
    {
        self.StartEndTrip.hidden = TRUE;
    }
    
    if(self.ShoppingTripItemList.count == 0)
    {
        self.AddTrip.enabled =TRUE;
        self.DeleteTrip.enabled =FALSE;
    }
    else
    {
        self.AddTrip.enabled = FALSE;
        self.DeleteTrip.enabled =TRUE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    EditShoppingItemViewController *editingView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditShoppingItemViewController"];
    
    editingView.shoppingItem = [self.ShoppingTripItemList objectAtIndex:tableView.indexPathForSelectedRow.row];
    
    [editingView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    // Pass the selected object to the new view controller.
    [self presentModalViewController:editingView animated:YES];
    //[self.navigationController pushViewController:editingView animated:YES];
}

- (void)viewDidUnload {
    [self setShoppingTripTV:nil];
    [self setAddTrip:nil];
    [self setStartEndTrip:nil];
    [self setLbDuration:nil];
    [self setLbTripName:nil];
    [self setLbBudget:nil];
    [self setDeleteTrip:nil];
    [super viewDidUnload];
}

- (IBAction)DeletePressed:(id)sender {
    
    [st deleteShoppingTrip:st.shoppingID];
    [self.ShoppingTripItemList removeAllObjects];
    self.lbDuration.text = @"Duration";
    self.lbBudget.text = @"Budget";
    self.lbTripName.text = @"Trip Name";
    [self.ShoppingTripTV reloadData];
    
    self.StartEndTrip.hidden = TRUE;

    if(self.ShoppingTripItemList.count == 0)
    {
        self.AddTrip.enabled =TRUE;
        self.DeleteTrip.enabled =FALSE;
    }
    else
    {
        self.AddTrip.enabled = FALSE;
        self.DeleteTrip.enabled =TRUE;
    }
}

- (IBAction)StartEndPressed:(id)sender {
    //Start and End Trip
    if([self.StartEndTrip.titleLabel.text isEqualToString:@"Start Trip"])
    {
        //Duration count down start
        st.shoppingTripCompleted = 1;
        [st updateShoppingTrip:st.shoppingID :st.shoppingTripCompleted];
        [self.StartEndTrip setTitle:@"End Trip" forState:UIControlStateNormal];
    }
    else if([self.StartEndTrip.titleLabel.text isEqualToString:@"End Trip"])
    {
        //Duration count down stop
        [self.StartEndTrip setTitle:@"Complete Trip" forState:UIControlStateNormal];
    }
    else
    {
        //Update Shopping Trip and Shopping Trip item
        //Update Shopping Trip and set ShoppingTripCompleted to TRUE
        st.shoppingTripCompleted = 2;
        [st updateShoppingTrip:st.shoppingID :st.shoppingTripCompleted];
        [self.ShoppingTripItemList removeAllObjects];
        self.lbDuration.text = @"Duration";
        self.lbBudget.text = @"Budget";
        self.lbTripName.text = @"Trip Name";
        [self.ShoppingTripTV reloadData];
        self.StartEndTrip.hidden = TRUE;
    }
}

- (IBAction)AddPressed:(id)sender {
    
    //Add and Delete Trip
    //[self.EditItemCategory setTitle:c.category_name forState:UIControlStateNormal];
}
@end

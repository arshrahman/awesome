//
//  PurchaseViewController.m
//  ToTe
//
//  Created by user on 24/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "PurchaseViewController.h"
#import "Purchase.h"
#import "AddPurchaseViewController.h"
#import "EditPurchaseViewController.h"
#import "customCell.h"

@interface PurchaseViewController ()
{
    NSString *check;
}

@end

@implementation PurchaseViewController

@synthesize PurchaseList = _PurchaseList;
@synthesize PurchaseListWeek = _PurchaseListWeek;
@synthesize Edit;
@synthesize PurchaseTableView =_PurchaseTableView;
@synthesize SortBy =_SortBy;

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
    // Do any additional setup after loading the view.
    //self.PurchaseTableView = [[UITableView alloc]init];
    
    Purchase *p = [[Purchase alloc]init];
    self.PurchaseList = [[NSMutableArray alloc]init];
    self.PurchaseList = [p viewTodayPurchases];
    
    //NSLog(@"This Week");
    Purchase *pp = [[Purchase alloc]init];
    self.PurchaseListWeek = [[NSMutableArray alloc]init];
    self.PurchaseListWeek = [pp viewThisWeekPurchases];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.PurchaseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell ==nil)
    {
        cell = [[customCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Purchase *currentPurchaseItem = [[Purchase alloc]init];
    
    if([check isEqualToString:@"This Week"])
    {
        currentPurchaseItem = [self.PurchaseListWeek objectAtIndex:indexPath.row];
    }
    else
    {
        currentPurchaseItem = [self.PurchaseList objectAtIndex:indexPath.row];
    }
    
    // Configure the cell...
    cell.customCellItemName.text = currentPurchaseItem.name;
    cell.customCellItemPrice.text = [NSString stringWithFormat: @"%.2lf", currentPurchaseItem.price];
    cell.customCellItemCategory.text = currentPurchaseItem.category;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    //NSLog([NSString stringWithFormat: @"%d", currentPurchaseItem.priority]);
    if(currentPurchaseItem.priority == 5)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
    }
    else if(currentPurchaseItem.priority == 4)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    else if(currentPurchaseItem.priority == 3)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    else if(currentPurchaseItem.priority == 2)
    {
        cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
    }
    else if(currentPurchaseItem.priority == 1)
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Purchase *p = [self.PurchaseList objectAtIndex:indexPath.row];
        //Call database method
        [p deletePurchase:p.uniqueId];
        
        // Delete the row from the data source
        [self.PurchaseList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Purchase *p = [self.PurchaseList objectAtIndex:fromIndexPath.row];
    [self.PurchaseList removeObjectAtIndex:fromIndexPath.row];
    [self.PurchaseList insertObject:p atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    //EditPurchaseViewController *editingView = [[EditPurchaseViewController alloc] initWithNibName:@"EditPurchaseViewController" bundle:nil];
    // ...
    
    EditPurchaseViewController *editingView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPurchaseViewController"];
    
    //EditPurchaseViewController *editPuchase = segue.destinationViewController;
    editingView.purchaseItem = [self.PurchaseList objectAtIndex:tableView.indexPathForSelectedRow.row];
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:editingView animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddItem"]){
        NSLog(@"push to addPurchaseViewController");
        UINavigationController *nav = segue.destinationViewController;
        
        AddPurchaseViewController *add = [nav.viewControllers objectAtIndex:0];
        add.purchaseViewController = self;
    }
    
    /*
     else if([segue.identifier isEqualToString:@"EditPurchaseViewController"])
     {
     NSLog(@"push to EditPurchaseViewController");
     //EditPurchaseViewController *editPuchase = segue.destinationViewController;
     
     //editPuchase.purchaseItem = [self.PurchaseList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
     
     EditPurchaseViewController *editPuchase = segue.destinationViewController;
     editPuchase.purchaseItem = [self.PurchaseList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
     }
     //NSLog(segue.identifier);
     */
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.PurchaseTableView reloadData];
}

//-(void)refresh:(UITableView *)tableview {
    //[tableview reloadData];
//}

- (IBAction)btnEdit:(id)sender {
    //self.editing = !self.editing;
    self.PurchaseTableView.editing = !self.PurchaseTableView.editing;
}
- (void)viewDidUnload {
    [self setEdit:nil];
    [self setSortBy:nil];
    [super viewDidUnload];
}

- (IBAction)Switch:(id)sender {
    NSLog(@"Switch");
    
    if(self.SortBy.selectedSegmentIndex == 0)
    {
        check = @"Today";
        Purchase *p = [[Purchase alloc]init];
        //self.PurchaseList = [[NSMutableArray alloc]init];
        self.PurchaseList = [p viewTodayPurchases];
        NSLog(@"Today");
        [self.PurchaseTableView reloadData];
    }
    else
    {
        check = @"This Week";
        Purchase *pp = [[Purchase alloc]init];
        //self.PurchaseListWeek = [[NSMutableArray alloc]init];
        self.PurchaseListWeek = [pp viewThisWeekPurchases];
        NSLog(@"This Week");
        [self.PurchaseTableView reloadData];
    }
}

@end


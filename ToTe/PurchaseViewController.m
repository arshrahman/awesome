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
#import "SettingsData.h"

@interface PurchaseViewController ()
{
    NSString *check;
    Purchase *purchaseItem;
}
@property (strong, nonatomic) NSMutableDictionary *individualDayPurchase;
@property (strong, nonatomic) NSArray *sortedDays;
@end

@implementation PurchaseViewController

@synthesize individualDayPurchase;
@synthesize sortedDays;
@synthesize ThisWeekDate = _ThisWeekDate;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([check isEqualToString:@"This Week"])
    {
        return self.sortedDays.count;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([check isEqualToString:@"This Week"])
    {
        NSString *date = [self.sortedDays objectAtIndex:section];
        NSMutableArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
        return [purchaseOnThisDay count];
        //return self.PurchaseListWeek.count;
        //NSString *date = [self.ThisWeekDate objectAtIndex:section];
        //self.PurchaseListWeek = [self.IndividualDayPurchase objectForKey:date];
        //return self.PurchaseListWeek.count;
    }
    else
    {
        return self.PurchaseList.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([check isEqualToString:@"This Week"])
    {
        NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = [dateFormatter dateFromString:dateRepresentingThisDay];
        
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
        NSString *dateWithNewFormat = [dateFormatter stringFromDate:date];
        
        return dateWithNewFormat;
        //self.PurchaseListWeek = [self.IndividualDayPurchase objectForKey:date];
    }
    else
    {
        //get current Date
        if(self.PurchaseList.count == 0)
        {
            return @"";
        }
        else
        {
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEEE, MMMM dd, yyyy"];
            
            NSString *theDate = [dateFormat stringFromDate:date];
            
            return theDate;
        }
    }
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
    NSString *date = [[NSString alloc]init];
    
    if([check isEqualToString:@"This Week"])
    {
        date = [self.sortedDays objectAtIndex:indexPath.section];
        NSMutableArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
        currentPurchaseItem = [purchaseOnThisDay objectAtIndex:indexPath.row];
    }
    else
    {
        currentPurchaseItem = [self.PurchaseList objectAtIndex:indexPath.row];
        
    }
    
    // Configure the cell...
    cell.customCellItemName.text = currentPurchaseItem.name;
    cell.customCellItemPrice.text = [NSString stringWithFormat: @"$%.2lf", currentPurchaseItem.price];
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
        
        if([check isEqualToString:@"This Week"])
        {
            NSString *date = [self.sortedDays objectAtIndex:indexPath.section];
            NSMutableArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
            Purchase *p = [purchaseOnThisDay objectAtIndex:indexPath.row];
            
            NSLog(@"%d", purchaseOnThisDay.count);
            
            NSLog(@"%d", indexPath.section);
            NSLog(@"%d", indexPath.row);
            
            [purchaseOnThisDay removeObjectAtIndex:indexPath.row];
            
            [self.PurchaseListWeek removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];

            
            //Call database method
            [p deletePurchase:p.uniqueId];
        }
        else
        {
            Purchase *p = [self.PurchaseList objectAtIndex:indexPath.row];
            //Call database method
            [p deletePurchase:p.uniqueId];
            
            // Delete the row from the data source
            [self.PurchaseList removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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
    
    
    //EditPurchaseViewController *editingView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPurchaseViewController"];
    
    EditPurchaseViewController *editingView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPurchaseViewController"];
    
    //EditPurchaseViewController *editPuchase = segue.destinationViewController;
    
    if([check isEqualToString:@"This Week"])
    {
        NSString *date = [self.sortedDays objectAtIndex:indexPath.section];
        NSMutableArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
        editingView.purchaseItem = [purchaseOnThisDay objectAtIndex:tableView.indexPathForSelectedRow.row];
        
        //editingView.purchaseItem = [self.PurchaseListWeek objectAtIndex:tableView.indexPathForSelectedRow.row];
    }
    else
    {
        editingView.purchaseItem = [self.PurchaseList objectAtIndex:tableView.indexPathForSelectedRow.row];
    }
    
    [editingView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    // Pass the selected object to the new view controller.
    [self presentModalViewController:editingView animated:YES];
    //[self.navigationController pushViewController:editingView animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddItem"]){
        NSLog(@"push to addPurchaseViewController");
        UINavigationController *nav = segue.destinationViewController;
        
        AddPurchaseViewController *add = [nav.viewControllers objectAtIndex:0];
        add.purchaseViewController = self;
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
    [self Refresh];
}

//Edit cell, curently not require.
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
    [self Refresh];
}

-(void)Refresh
{
    if(self.SortBy.selectedSegmentIndex == 0)
    {
        check = @"Today";
        Purchase *p = [[Purchase alloc]init];
        self.PurchaseList = [[NSMutableArray alloc]init];
        self.PurchaseList = [p viewTodayPurchases];
        NSLog(@"Today");
        [self.PurchaseTableView reloadData];
    }
    else
    {
        check = @"This Week";
        Purchase *pp = [[Purchase alloc]init];
        self.PurchaseListWeek = [[NSMutableArray alloc]init];
        self.PurchaseListWeek = [pp viewThisWeekPurchases];
        
        self.IndividualDayPurchase = [[NSMutableDictionary alloc]init];
        
        NSString *date = [[NSString alloc]init];
        
        for(Purchase *ppp in self.PurchaseListWeek)
        {
            date = ppp.date;
            
            NSMutableArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
            
            if(purchaseOnThisDay == nil)
            {
                purchaseOnThisDay = [NSMutableArray array];
                
                [self.individualDayPurchase setObject:purchaseOnThisDay forKey:date];
            }
            
            [purchaseOnThisDay addObject:ppp];
        }
        
        // Create a sorted list of days
        NSArray *unsortedDays = [self.individualDayPurchase allKeys];
        self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
        
        NSLog(@"This Week");
        [self.PurchaseTableView reloadData];
    }
}

@end


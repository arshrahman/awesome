//
//  PurchasedItemsViewController.m
//  ToTe
//
//  Created by Pol on 1/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "PurchasedItemsViewController.h"
#import "Purchase.h"
#import "ShoppingTripItem.h"
#import "customCell.h"
#import "CombinePurchases.h"
//#import "DatePurchasedViewController.h"

@interface PurchasedItemsViewController ()

@property (strong, nonatomic) NSMutableDictionary *individualDayPurchase;
@property (strong, nonatomic) NSArray *sortedDays;

@end


@implementation PurchasedItemsViewController

@synthesize PurchasedItemsUITableView;
@synthesize PurchaseList = _PurchaseList;
@synthesize ShoppingList = _ShoppingList;
@synthesize CombineList = _CombineList;
@synthesize individualDayPurchase;
@synthesize sortedDays;


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortedDays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *date = [self.sortedDays objectAtIndex:section];
    NSMutableArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
    return [purchaseOnThisDay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell ==nil)
    {
        cell = [[customCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CombinePurchases *currentPurchaseItem = [[CombinePurchases alloc]init];

    NSString *date = [[NSString alloc]init];
    
    date = [self.sortedDays objectAtIndex:indexPath.section];
    NSMutableArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
    currentPurchaseItem = [purchaseOnThisDay objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.customCellItemName.text = currentPurchaseItem.name;
    cell.customCellItemPrice.text = [NSString stringWithFormat: @"$%.2lf", currentPurchaseItem.price];
    cell.customCellItemCategory.text = currentPurchaseItem.category;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
    NSDate *date = [dateFormatter dateFromString:dateRepresentingThisDay];
        
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    NSString *dateWithNewFormat = [dateFormatter stringFromDate:date];
        
    return dateWithNewFormat;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Refresh];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)Refresh
{
    Purchase *pp = [[Purchase alloc]init];
    self.PurchaseList = [[NSMutableArray alloc]init];
    self.PurchaseList = [pp viewAllPurchases];
    NSLog(@"Purchase List : %d", [self.PurchaseList count]);
    
    ShoppingTripItem *ss = [[ShoppingTripItem alloc]init];
    self.ShoppingList = [[NSMutableArray alloc]init];
    self.ShoppingList = [ss getShoppingTrip];
    NSLog(@"Shopping List : %d", [self.ShoppingList count]);
    
    //combine the array
    self.CombineList = [[self.PurchaseList arrayByAddingObjectsFromArray:self.ShoppingList]mutableCopy];
    
    NSLog(@"Combine List : %d", [self.CombineList count]);
    //self.PurchaseList = [[dataArray arrayByAddingObjectsFromArray:dataArray1] mutableCopy];
    
    self.individualDayPurchase = [[NSMutableDictionary alloc]init];
        
    NSString *date = [[NSString alloc]init];
    
    for(CombinePurchases *ppp in self.CombineList)
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
        
    [self.PurchasedItemsUITableView reloadData];
    
}


@end

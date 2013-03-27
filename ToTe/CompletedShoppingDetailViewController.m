//
//  CompletedShoppingDetailViewController.m
//  ToTe
//
//  Created by Pol on 22/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "CompletedShoppingDetailViewController.h"
#import "customCell.h"
#import "customCell1.h"
#import "customCell2.h"
#import "ShoppingTrip.h"
#import "ShoppingTripItem.h"

@interface CompletedShoppingDetailViewController ()
{
    ShoppingTrip *trip;
    ShoppingTripItem *item;
}

@end

@implementation CompletedShoppingDetailViewController

@synthesize ShoppingTripItemList;
@synthesize ShoppingTripList;
@synthesize ShoppingTripTV;
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
	// Do any additional setup after loading the view.
    trip = [[ShoppingTrip alloc] init];
    item = [[ShoppingTripItem alloc]init];
    ShoppingTrip *s = [[ShoppingTrip alloc] init];
    ShoppingTripItem *i = [[ShoppingTripItem alloc]init];
    self.ShoppingTripList = [s SelectCompletedShopping];
    self.ShoppingTripItemList = [i getShoppingTripItem:self.ShoppingTripID];
    NSLog(@"%d", self.ShoppingTripItemList.count);
    for(ShoppingTrip *st in self.ShoppingTripList)
    {
        if(st.shoppingID == self.ShoppingTripID)
        {
            trip = st;
            break;
        }
    }
    
    lbBudget.text = [NSString stringWithFormat:@"$%.2lf", trip.shoppingBudget];
    lbDuration.text = trip.Duration;
    lbTripName.text = trip.shoppingTripName;
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
    
    customCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell ==nil)
    {
        cell = [[customCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

@end

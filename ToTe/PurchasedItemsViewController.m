//
//  PurchasedItemsViewController.m
//  ToTe
//
//  Created by Pol on 1/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "PurchasedItemsViewController.h"
#import "Purchase.h"
#import "customCell.h"
//#import "DatePurchasedViewController.h"

@interface PurchasedItemsViewController ()

@end

@implementation PurchasedItemsViewController

@synthesize PurchasedItemsUITableView;
@synthesize PurchaseList = _PurchaseList;
@synthesize PurchaseListWeek = _PurchaseListWeek;

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
    self.PurchaseList = [p viewAllPurchases];
    NSLog(@"%d",self.PurchaseList.count);
    /*
     Purchase *pp = [[Purchase alloc]init];
     self.PurchaseListWeek = [[NSMutableArray alloc]init];
     self.PurchaseListWeek = [pp viewThisWeekPurchases];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

    currentPurchaseItem = [self.PurchaseList objectAtIndex:indexPath.row];
    
    
    // Configure the cell...
    cell.customCellItemName.text = currentPurchaseItem.name;
    cell.customCellItemPrice.text = [NSString stringWithFormat: @"%.2lf", currentPurchaseItem.price];
    cell.customCellItemCategory.text = currentPurchaseItem.category;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DatePurchasedViewController *datePurchased =[self.storyboard instantiateViewControllerWithIdentifier:@"DatePurchasedViewController"];
//    
//    datePurchased.purchaseItem = [self.PurchaseList objectAtIndex:tableView.indexPathForSelectedRow.row];
//    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:datePurchased animated:YES];
//}

@end

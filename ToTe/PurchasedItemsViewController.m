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

@property (strong, nonatomic) NSMutableDictionary *individualDayPurchase;
@property (strong, nonatomic) NSArray *sortedDays;

@end


@implementation PurchasedItemsViewController

@synthesize PurchasedItemsUITableView;
@synthesize PurchaseList = _PurchaseList;
@synthesize PurchaseListWeek = _PurchaseListWeek;

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
    return self.sortedDays.count;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.PurchaseList.count;   
//}

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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if([check isEqualToString:@"This Week"])
//    {
        NSString *date = [self.sortedDays objectAtIndex:section];
        NSArray *purchaseOnThisDay = [self.individualDayPurchase objectForKey:date];
        return [purchaseOnThisDay count];
        //return self.PurchaseListWeek.count;
        //NSString *date = [self.ThisWeekDate objectAtIndex:section];
        //self.PurchaseListWeek = [self.IndividualDayPurchase objectForKey:date];
        //return self.PurchaseListWeek.count;
//    }
//    else
//    {
//        return self.PurchaseList.count;
//    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if([check isEqualToString:@"This Week"])
//    {
        NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = [dateFormatter dateFromString:dateRepresentingThisDay];
        
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
        NSString *dateWithNewFormat = [dateFormatter stringFromDate:date];
        
        return dateWithNewFormat;
        //self.PurchaseListWeek = [self.IndividualDayPurchase objectForKey:date];
//    }
//    else
//    {
//        //get current Date
//        if(self.PurchaseList.count == 0)
//        {
//            return @"";
//        }
//        else
//        {
//            NSDate *date = [NSDate date];
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//            [dateFormat setDateFormat:@"EEEE, MMMM dd, yyyy"];
//            
//            NSString *theDate = [dateFormat stringFromDate:date];
//            
//            return theDate;
//        }
//    }
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Refresh];
}


- (void)viewDidUnload {
//    [self setEdit:nil];
//    [self setSortBy:nil];
    [super viewDidUnload];
}


-(void)Refresh
{
        Purchase *pp = [[Purchase alloc]init];
        //self.PurchaseListWeek = [[NSMutableArray alloc]init];
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
        [self.PurchasedItemsUITableView reloadData];
    
}


@end

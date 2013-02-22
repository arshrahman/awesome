//
//  CompletedShoppingViewController.m
//  ToTe
//
//  Created by Pol on 22/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "CompletedShoppingViewController.h"
#import "CompletedGoalsViewController.h"
#import "ShoppingTrip.h"
#import "ShoppingTripItem.h"
#import "CompletedShoppingDetailViewController.h"

@interface CompletedShoppingViewController ()
{
    NSMutableArray *shoppingTripArray;
    NSMutableArray *shoppingTripItemArray;
    ShoppingTrip *st;
    ShoppingTripItem *si;
}

@end

@implementation CompletedShoppingViewController 

@synthesize tblViewShop;

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
    st = [[ShoppingTrip alloc]init];
    shoppingTripArray = [[NSMutableArray alloc]init];
    shoppingTripItemArray = [[NSMutableArray alloc]init];
    shoppingTripArray = [st SelectCompletedShopping];
    
}


-(void)viewWillAppear:(BOOL)animated
{
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shoppingTripArray.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ShoppingTrip *sTrip = [[ShoppingTrip alloc ]init];
    sTrip = [shoppingTripArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = sTrip.shoppingTripName;
    cell.detailTextLabel.text = sTrip.shoppingDate;
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ShoppingTrip *ggl = [goalArray objectAtIndex:indexPath.row];
//    
//    CompletedShoppingDetailViewController *sdc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompletedShoppingDetailViewController"];
//    sdc.goal_id = ggl.goal_id;
//    
//    sdc.goalTitle = ggl.goal_title;
//    
//    [self.navigationController pushViewController:sdc animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTblViewShop:nil];
    [super viewDidUnload];
}

@end


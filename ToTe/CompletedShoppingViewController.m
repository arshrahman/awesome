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
    
}


-(void)viewWillAppear:(BOOL)animated
{
   
    
    st = [[ShoppingTrip alloc]init];
    shoppingTripArray = [[NSMutableArray alloc]init];
    shoppingTripItemArray = [[NSMutableArray alloc]init];
    
   
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
    static NSString *goalTbViewCell = @"goalTbViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goalTbViewCell"];
    
    UILabel *lblname = nil;
    UILabel *lbldate = nil;
    UIImageView *imv = nil;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goalTbViewCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
        
        lblname = [[UILabel alloc]initWithFrame:CGRectMake(63, 3, 280, 25)];
        lblname.textColor = [UIColor blackColor];
        lblname.font = [UIFont fontWithName:@"Helvetica" size:17];
        lblname.text = @"";
        lblname.tag = 100;
        
        lbldate = [[UILabel alloc]initWithFrame:CGRectMake(63, 26, 280, 25)];
        lbldate.textColor = [UIColor blackColor];
        lbldate.font = [UIFont fontWithName:@"Helvetica" size:16];
        lbldate.textColor = [UIColor darkGrayColor];
        lbldate.tag = 200;
        
        imv = [[UIImageView alloc]initWithFrame:CGRectMake(11, 10, 41, 35)];
        imv.image=[UIImage imageNamed:@"glyphicons_138_picture.png"];
        imv.layer.cornerRadius = 5.0;
        imv.clipsToBounds = YES;
        imv.tag = 300;
        
        [cell.contentView addSubview:lblname];
        [cell.contentView addSubview:lbldate];
        [cell.contentView addSubview:imv];
    }
    else
    {
        lblname = (UILabel *)[cell.contentView viewWithTag:100];
        lbldate = (UILabel *)[cell.contentView viewWithTag:200];
        imv = (UIImageView *)[cell.contentView viewWithTag:300];
    }
    
    
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


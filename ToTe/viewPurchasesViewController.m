//
//  viewPurchasesViewController.m
//  ToTe
//
//  Created by user on 14/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "viewPurchasesViewController.h"
#import "Database.h"
#import "Purchase.h"

@interface viewPurchasesViewController ()

@end

@implementation viewPurchasesViewController

@synthesize purchasesList;

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
    Database *db = [[Database alloc]init];
    [db viewPurchases];
    
    
}

-(NSInteger)numberOfScetionsInTabView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    //return [purchasesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    UILabel *lbName = nil;
    UILabel *lbCategory = nil;
    UILabel *lbPrice = nil;
    
    NSLog(@"Haven't create labels");
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        
        Purchase *p = [purchasesList objectAtIndex:indexPath.row];
        
        lbName.text = p.name;
        lbPrice.text = [NSString stringWithFormat:@"%.2f", p.price];
        lbCategory.text = p.category;
        
        NSLog(@"Creating label");
        
        lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 185, 30)];
        //lbName.text = [NSString stringWithFormat:@"Name: %d", indexPath.row];
        lbName.font = [UIFont systemFontOfSize:20];
        lbName.tag = 100;
        lbName.textColor = [UIColor blackColor];
        lbCategory = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 10)];
        lbCategory.font = [UIFont systemFontOfSize:10];
        //lbCategory.text = @"Category: ";
        lbCategory.tag = 100;
        lbCategory.textColor = [UIColor blackColor];
        lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 185, 30)];
        lbPrice.font = [UIFont systemFontOfSize:30];
        //lbPrice.text = @"Price: ";
        lbPrice.tag = 100;
        lbPrice.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbName];
        [cell.contentView addSubview:lbCategory];
        [cell.contentView addSubview:lbPrice];

    } else {
        lbName = (UILabel *)[cell.contentView viewWithTag:100];
        lbCategory = (UILabel *)[cell.contentView viewWithTag:100];
        lbPrice = (UILabel *)[cell.contentView viewWithTag:100];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Index row of this cell: %d", indexPath.row];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

//
//  ByCategoryViewController.m
//  ToTe
//
//  Created by Pol on 4/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ByCategoryViewController.h"

@interface ByCategoryViewController ()

@end

@implementation ByCategoryViewController

@synthesize ByCategoryUITableView;

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.BudgetList.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
//    Budget *weeklyBudget = [[Budget alloc]init];
//    
//    weeklyBudget = [self.BudgetList objectAtIndex:indexPath.row];
//    
//    
//    // Configure the cell...
//    int budget_id = weeklyBudget.budget_id;
//    double expenses =weeklyBudget.GetExpenses;
//    
//    //    double expenses =  [self GetCurentExpenses:budget_id];
//    //    [weeklyBudget GetCurrentExpenses:budget_id];
//    
//    //    NSString *start = weeklyBudget.startDate;
//    //    NSString *begin = [start substringToIndex:10];
//    //    NSString *end = weeklyBudget.endDate;
//    //    NSString *last = [end substringToIndex:10];
//    
//    NSString *dateRepresentingStartDay = weeklyBudget.startDate;
//    NSString *dateRepresentingEndDay = weeklyBudget.endDate;
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *dateStart = [dateFormatter dateFromString:dateRepresentingStartDay];
//    [dateFormatter setDateFormat:@"MMMM-dd-yyyy"];
//    NSString *dateWithNewFormatStart = [dateFormatter stringFromDate:dateStart];
//    
//    NSDate *dateEnd = [dateFormatter dateFromString:dateRepresentingEndDay];
//    NSString *dateWithNewFormatEnd = [dateFormatter stringFromDate:dateEnd];
//    
//    NSString *combined = [dateWithNewFormatStart stringByAppendingString:@" to "];
//    //NSString *full = [combined stringByAppendingString:dateWithNewFormatEnd];
//    NSLog (dateWithNewFormatStart);
//    NSLog (@"%f", expenses);
//    NSLog (@"%@", dateEnd);
//    NSLog (dateRepresentingEndDay);
//    NSLog (dateWithNewFormatEnd);
//    
//    cell.textLabel.text = combined;
//    cell.detailTextLabel.text= [NSString stringWithFormat:@"%2.1f/%2.1f", expenses,
//                                weeklyBudget.budget_amount];
//    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    return cell;
//    
}


@end

//
//  ByWeekViewController.m
//  ToTe
//
//  Created by Pol on 21/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ByWeekViewController.h"
#import "Database.h"
#import "sqlite3.h"
#import "Budget.h"
#import "ViewBudgetViewController.h"

@interface ByWeekViewController ()
{
    //some checking for the array
    NSString *checkDate;
}

@end

@implementation ByWeekViewController
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    NSMutableArray *ByWeekNSMutalbleArray;
}

//@synthesize ByWeekUITableView;
@synthesize BudgetList = _BudgetList;


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
    Budget *b = [[Budget alloc]init];
    self.BudgetList = [[NSMutableArray alloc]init];
    self.BudgetList = [b viewAllBudget];
    NSLog(@"%d", self.BudgetList.count);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    //[self setByWeekUITableView:nil];
    [super viewDidUnload];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.BudgetList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Budget *weeklyBudget = [[Budget alloc]init];
    
    weeklyBudget = [self.BudgetList objectAtIndex:indexPath.row];
    
    
    // Configure the cell...
    int budget_id = weeklyBudget.budget_id;
    //double expenses =weeklyBudget.GetExpenses;
    NSLog (@"expenses go here");
    double expenses =  [weeklyBudget GetExpenses:budget_id];
//    [weeklyBudget GetCurrentExpenses:budget_id];
    
//    NSString *start = weeklyBudget.startDate;
//    NSString *begin = [start substringToIndex:10];
//    NSString *end = weeklyBudget.endDate;
//    NSString *last = [end substringToIndex:10];
    
    NSString *dateRepresentingStartDay = weeklyBudget.startDate;
    NSString *dateRepresentingEndDay = weeklyBudget.endDate;
//    NSLog (dateRepresentingEndDay);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateStart = [dateFormatter dateFromString:dateRepresentingStartDay];
    NSDate *dateEnd = [dateFormatter dateFromString:dateRepresentingEndDay];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateWithNewFormatStart = [dateFormatter stringFromDate:dateStart];
    NSString *dateWithNewFormatEnd = [dateFormatter stringFromDate:dateEnd];
    
    NSString *combined = [dateWithNewFormatStart stringByAppendingString:@" to "];
    NSString *full = [combined stringByAppendingString:dateWithNewFormatEnd];
    
    cell.textLabel.text = full;
    cell.detailTextLabel.text= [NSString stringWithFormat:@"%2.1f/%2.1f", expenses,
                                weeklyBudget.budget_amount];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewBudgetViewController *viewBudget =[self.storyboard instantiateViewControllerWithIdentifier:@"ViewBudgetViewController"];
    
    viewBudget.budgetItem = [self.BudgetList objectAtIndex:tableView.indexPathForSelectedRow.row];
    // Pass the selected object to the new view controller.
    
    NSString *dateRepresentingStartDay = viewBudget.budgetItem.startDate;
    NSString *dateRepresentingEndDay = viewBudget.budgetItem.endDate;
    //    NSLog (dateRepresentingEndDay);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateStart = [dateFormatter dateFromString:dateRepresentingStartDay];
    NSDate *dateEnd = [dateFormatter dateFromString:dateRepresentingEndDay];
    [dateFormatter setDateFormat:@"dd MMM"];
    NSString *dateWithNewFormatStart = [dateFormatter stringFromDate:dateStart];
    NSString *dateWithNewFormatEnd = [dateFormatter stringFromDate:dateEnd];
    
    NSString *combined = [dateWithNewFormatStart stringByAppendingString:@" to "];
    NSString *full = [combined stringByAppendingString:dateWithNewFormatEnd];
    
    viewBudget.dateWeek = full;
    
     NSLog(@"%d", viewBudget.budgetItem.budget_id);
    [self.navigationController pushViewController:viewBudget animated:YES];
   

}


@end

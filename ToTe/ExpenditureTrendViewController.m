//
//  ExpenditureTrendViewController.m
//  ToTe
//
//  Created by user on 21/3/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ExpenditureTrendViewController.h"
#import "ExpenditureTrendGraphViewController.h"
#import "Budget.h"

@interface ExpenditureTrendViewController ()

@end

@implementation ExpenditureTrendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return containerOfAllTheEightWeeks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Budget *b1 = [[Budget alloc]init];
    Budget *b2 = [[Budget alloc]init];
    
    NSMutableArray *eightWeek = [containerOfAllTheEightWeeks objectAtIndex:indexPath.row];
    b1 = [eightWeek objectAtIndex:0];
    b2 = [eightWeek lastObject];
    
    NSString *start = b1.startDate;
    NSString *end = b2.endDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *start1 = [formatter dateFromString:start];
    NSDate *end1 = [formatter dateFromString:end];
    
    //[self getBetweenDates:start1:end1];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    
    start = [dateFormat stringFromDate:start1];
    end = [dateFormat stringFromDate:end1];
    
    //b = [ objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"No. of Expenditure weeks: %d", eightWeek.count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"From: %@  To: %@", start, end];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
/*
-(void)getBetweenDates:(NSDate *)startDate :(NSDate *)endDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    [offset setDay:1];
    
    [eightWeeksBudgetDates removeAllObjects];
    
    NSLog(@"%@",startDate);
    
    NSDate *curDate = startDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    while([curDate timeIntervalSince1970] <= [endDate timeIntervalSince1970])
    {
        NSString *date = [dateFormat stringFromDate:curDate];
        
        [eightWeeksBudgetDates addObject:date];
        
        curDate = [calendar dateByAddingComponents:offset toDate:curDate options:0];
    }
    
    NSString *date2 = [dateFormat stringFromDate:endDate];
    
    [eightWeeksBudgetDates insertObject:date2 atIndex:eightWeeksBudgetDates.count];
    
    [containerOfAllTheEightWeeksDates addObject:eightWeeksBudgetDates];
    
    NSLog(@"%@",eightWeeksBudgetDates);
    NSLog(@"%@",containerOfAllTheEightWeeksDates);
}
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpenditureTrendGraphViewController *EG = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpenditureTrendGraphViewController"];
     EG.ID = tableView.indexPathForSelectedRow.row;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:EG animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getExpendAndSaving];
}

-(NSMutableArray *)getExpendAndSaving
{
    Budget *b = [[Budget alloc]init];
    allBudget = [[NSMutableArray alloc]init];
    containerOfAllTheEightWeeks = [[NSMutableArray alloc]init];
    eightWeeksBudget = [[NSMutableArray alloc]init];
    
    allBudget = [b viewAllBudget];
    int count = 0;
    for(Budget *bb in allBudget)
    {
        if(allBudget.count > 8)
        {
            if(count < 8)
            {
                [eightWeeksBudget addObject:bb];
                count++;
            }
            else if(count == 8)
            {
                NSLog(@"8");
                [containerOfAllTheEightWeeks addObject:eightWeeksBudget];
                count = 0;
                [eightWeeksBudget removeAllObjects];
            }
        }
        else
        {
            [eightWeeksBudget addObject:bb];
            count++;
            if(count == allBudget.count)
            {
                [containerOfAllTheEightWeeks addObject:eightWeeksBudget];
            }
        }
    }
    
    return containerOfAllTheEightWeeks;
}

@end

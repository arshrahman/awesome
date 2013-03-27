//
//  ByCategoryDateViewController.m
//  ToTe
//
//  Created by user on 26/3/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ByCategoryDateViewController.h"
#import "ByCategoryGraphViewController.h"
#import "Budget.h"
#import "Category.h"
@interface ByCategoryDateViewController ()
{
    NSMutableArray *categoryList;
}

@end

@implementation ByCategoryDateViewController

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
    Category *c = [[Category alloc]init];
    categoryList = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        if(cc.category_id == self.categoryID)
        {
            c = cc;
            [self.navigationItem setTitle:cc.category_name];
        }
        
        [categoryList addObject:cc];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    
    start = [dateFormat stringFromDate:start1];
    end = [dateFormat stringFromDate:end1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"No. of weeks: %d", eightWeek.count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"From: %@  To: %@", start, end];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

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
    ByCategoryGraphViewController *CG = [self.storyboard instantiateViewControllerWithIdentifier:@"ByCategoryGraphViewController"];
    
    //insert the data you want to pass over here.
    CG.ID = tableView.indexPathForSelectedRow.row;
    CG.categoryID = self.categoryID;
    
    NSLog(@"%d", CG.ID);
    NSLog(@"%d", CG.categoryID);
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:CG animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getEightWeekBudget];
}

-(NSMutableArray *)getEightWeekBudget
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

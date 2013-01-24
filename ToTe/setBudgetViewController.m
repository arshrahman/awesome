//
//  setBudgetViewController.m
//  ToTe
//
//  Created by user on 3/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "setBudgetViewController.h"
#import "Database.h"
#import "Budget.h"
#import "BudgetCategory.h"
#import "BudgetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface setBudgetViewController ()

@end

@implementation setBudgetViewController
{
    NSMutableArray *topArray;
    NSMutableArray *bottomArray;
    NSMutableArray *catList;
    Budget *b;
    double income;
    double expenses;
}

@synthesize topView;
@synthesize bottomView;
@synthesize sideView;
@synthesize scroller;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *ns = [[NSUserDefaults standardUserDefaults]objectForKey:@"FirstTimeUser"];
    int FirstTimeUse = [ns intValue];
    
    if (FirstTimeUse != 3)
    {
        BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
        [self.navigationController pushViewController:svc animated:YES];

    }
    else
    {
        topArray = [[NSMutableArray alloc]init];
        bottomArray = [[NSMutableArray alloc]init];
        catList = [[NSMutableArray alloc]init];
        b = [[Budget alloc]init];
                
        for(Budget *bb in [b GetIncomeBudget])
        {
            [topArray addObject:bb];
        }

        expenses = b.GetExpenses;
        income = [[topArray objectAtIndex:0] doubleValue];
        NSLog(@"Current Expenses: %f", expenses);
        
        [bottomArray addObject:[NSNumber numberWithDouble:expenses]];
        [bottomArray addObject:[NSNumber numberWithDouble:income - expenses]];
        
        for (BudgetCategory *bc in b.GetBudgetCategories)
        {
            //NSLog(@"bc: %@", bc.bcategory_name);
            [catList addObject:bc];
        }
        
        sideView = [[UITableView alloc] initWithFrame:CGRectMake(347, 8, 270, 130) style:UITableViewStylePlain];
        sideView.delegate = self;
        sideView.dataSource = self;
        
        [scroller addSubview:sideView];

        UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(secondPage:)];
        leftSwipeGestureRecognizer.numberOfTouchesRequired = 1;
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [scroller addGestureRecognizer:leftSwipeGestureRecognizer];
        

        UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(firstPage:)];
        rightSwipeGestureRecognizer.numberOfTouchesRequired = 1;
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [scroller addGestureRecognizer:rightSwipeGestureRecognizer];


        topView.layer.cornerRadius = 10.0f;
        topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        topView.layer.borderWidth = 1.5;
        
        bottomView.layer.cornerRadius = 10.0f;
        bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bottomView.layer.borderWidth = 1.5;
        bottomView.scrollEnabled = NO;
        
        sideView.layer.cornerRadius = 10.0f;
        sideView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        sideView.layer.borderWidth = 1.5;
    }
}

- (void)secondPage:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    pageControl.currentPage = 1;
    [scroller setContentOffset:CGPointMake(320, 0) animated:YES];
   
}

- (void)firstPage:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    pageControl.currentPage = 0;
    [scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
	
	if(tableView == topView) rows = [topArray count];
	if(tableView == bottomView) rows = [bottomArray count];
    if(tableView == sideView) rows = catList.count;
	
	return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *TopTableCell = @"TopTableCell";
    static NSString *BottomTableCell = @"BottomTableCell";
    static NSString *SideTableCell = @"SideTableCell";
	
	
	if(tableView == topView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TopTableCell];
        
        UILabel *lblname = nil;
        UILabel *lblamount = nil;
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopTableCell];
            
            lblname = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 60)];
            lblname.textColor = [UIColor blackColor];
            lblname.font = [UIFont fontWithName:@"Helvetica" size:18];
            lblname.text = @"Weekly Income:";
            //lblname.textAlignment = NSTextAlignmentCenter;
            //[lblname sizeToFit];
            lblname.tag = 100;
            
            lblamount = [[UILabel alloc]initWithFrame:CGRectMake(156, 0, 130, 60)];
            lblamount.textColor = [UIColor blackColor];
            lblamount.font = [UIFont fontWithName:@"Helvetica" size:25];
            lblamount.font = [UIFont boldSystemFontOfSize:25 ];
            //lblname.textAlignment = NSTextAlignmentCenter;
            //[lblamount sizeToFit];
            lblamount.tag = 200;
            
            [cell.contentView addSubview:lblname];
            [cell.contentView addSubview:lblamount];
        }
        else
        {
            lblname = (UILabel *)[cell.contentView viewWithTag:100];
            lblamount = (UILabel *)[cell.contentView viewWithTag:200];
        }
        
        if (indexPath.row == 1)lblname.text = @"Weekly Budget:";
        lblamount.text = [NSString stringWithFormat:@"$%@", [[topArray objectAtIndex:indexPath.row] stringValue]];
        
        return cell;
    }
    
	else if(tableView == bottomView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BottomTableCell];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BottomTableCell];
        }
        
        cell.textLabel.text = [[bottomArray objectAtIndex:indexPath.row] stringValue];
        //cell.textLabel.text = @"Current Savings: $100";
        
        return cell;
    }
    
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SideTableCell];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SideTableCell];
        }
        
        BudgetCategory *bc = [catList objectAtIndex:indexPath.row];
        cell.textLabel.text = bc.bcategory_name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)pageControl:(id)sender
{
    if (pageControl.currentPage == 0)
    {
        [scroller setContentOffset:CGPointMake(320, 0) animated:YES];
    }
    else
    {
        [scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


- (IBAction)btnClicked:(id)sender
{
    [scroller setContentOffset:CGPointMake(320, 0) animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setScroller:nil];
    [super viewDidUnload];
}
@end

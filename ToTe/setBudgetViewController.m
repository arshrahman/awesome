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
#import "BudgetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface setBudgetViewController ()

@end

@implementation setBudgetViewController
{
    NSMutableArray *topArray;
    NSMutableArray *bottomArray;
    NSMutableArray *catList;
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
    NSLog(@"user: %d", FirstTimeUse);
    
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
        
        sideView = [[UITableView alloc] initWithFrame:CGRectMake(343, 8, 274, 131) style:UITableViewStylePlain];
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
    NSInteger sections;
	
	if(tableView == topView) sections = 2;
	if(tableView == bottomView) sections = 1;
	if(tableView == sideView) sections = 1;
    
	return sections;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
	
	if(tableView == topView) rows = [topArray count] + 1;
	if(tableView == bottomView) rows = [bottomArray count] + 2;
    if(tableView == sideView) rows = 2;
	
	return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"TwoTablesCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	if(tableView == topView)
		//cell.textLabel.text = [topArray objectAtIndex:indexPath.row];
        cell.textLabel.text = @"Income : $120";
	if(tableView == bottomView)
        //cell.textLabel.text = [bottomArray objectAtIndex:indexPath.row];
        cell.textLabel.text = @"Current Savings: $100";
    if(tableView == sideView)
		//cell.textLabel.text = [topArray objectAtIndex:indexPath.row];
        cell.textLabel.text = @"Banana";
        
	return cell;

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

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
#import "UpdateBudgetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Database.h"
#import "BudgetViewController.h"

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
    int weekday;
    BOOL allowEdit;
    
    CMPopTipView *tooltip;
}

@synthesize topView;
@synthesize bottomView;
@synthesize sideView;
@synthesize scroller;
@synthesize pageControl;
@synthesize topButton;

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
    
    [self.tabBarController setDelegate:self];
    sideView = [[UITableView alloc] initWithFrame:CGRectMake(340, 8, 280, 150) style:UITableViewStylePlain];
    sideView.delegate = self;
    sideView.dataSource = self;
    sideView.rowHeight = 50;
    
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
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    weekday = [comp weekday];
    allowEdit = FALSE;
    
    if (weekday == 2 || weekday == 3)
    {
        allowEdit = TRUE;
        topButton.tintColor = [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:0/255.0 alpha:1];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    animated = NO;
    self.navigationItem.hidesBackButton = YES;
    
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
    
    [bottomArray addObject:[NSNumber numberWithDouble:expenses]];
    [bottomArray addObject:[NSNumber numberWithDouble:income - expenses]];
    
    for (BudgetCategory *bc in b.GetBudgetCategories)
    {
        [catList addObject:bc];
    }
    
    [topView reloadData];
    [bottomView reloadData];
    [sideView reloadData];
}

- (void)secondPage:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    pageControl.currentPage = 1;
    [scroller setContentOffset:CGPointMake(320, 0) animated:YES];
   
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
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
        UIImageView *imv = nil;
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopTableCell];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            lblname = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 157, 60)];
            lblname.textColor = [UIColor blackColor];
            lblname.font = [UIFont fontWithName:@"Helvetica" size:17];
            lblname.text = @"Weekly\nIncome:";
            lblname.lineBreakMode = UILineBreakModeWordWrap;
            lblname.numberOfLines = 2;
            lblname.tag = 100;
            
            lblamount = [[UILabel alloc]initWithFrame:CGRectMake(157, 0, 130, 60)];
            lblamount.textColor = [UIColor blackColor];
            lblamount.font = [UIFont fontWithName:@"Helvetica" size:21];
            lblamount.font = [UIFont boldSystemFontOfSize:21 ];
            lblamount.tag = 200;
            
            imv = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 18, 26)];
            imv.image=[UIImage imageNamed:@"glyphicons_227_usd.png"];
            imv.tag = 300;
            
            [cell.contentView addSubview:lblname];
            [cell.contentView addSubview:lblamount];
            [cell.contentView addSubview:imv];
        }
        else
        {
            lblname = (UILabel *)[cell.contentView viewWithTag:100];
            lblamount = (UILabel *)[cell.contentView viewWithTag:200];
            imv = (UIImageView *)[cell.contentView viewWithTag:300];
        }
        
        if (indexPath.row == 1)
        {
            lblname.text = @"Weekly\nBudget:";
            imv.image=[UIImage imageNamed:@"glyphicons_325_wallet.png"];
            
        }
        lblamount.text = [NSString stringWithFormat:@"$%g", [[topArray objectAtIndex:indexPath.row] doubleValue]];
        
        return cell;
    }
    
	else if(tableView == bottomView)
    {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:BottomTableCell];
        
        UILabel *lblcurrent = nil;
        UILabel *lbltotal = nil;
        UIImageView *img = nil;
        
        if(cell1 == nil)
        {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BottomTableCell];
            cell1.selectionStyle = UITableViewCellSelectionStyleGray;
                        
            lblcurrent = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 157, 60)];
            lblcurrent.textColor = [UIColor blackColor];
            lblcurrent.font = [UIFont fontWithName:@"Helvetica" size:17];
            lblcurrent.text = @"Current\nExpenses:";
            lblcurrent.lineBreakMode = UILineBreakModeWordWrap;
            lblcurrent.numberOfLines = 2;
            lblcurrent.tag = 400;
            
            lbltotal = [[UILabel alloc]initWithFrame:CGRectMake(157, 0, 130, 60)];
            lbltotal.textColor = [UIColor blackColor];
            lbltotal.font = [UIFont fontWithName:@"Helvetica" size:21];
            lbltotal.font = [UIFont boldSystemFontOfSize:21 ];
            lbltotal.tag = 500;
            
            img = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 25, 25)];
            img.image=[UIImage imageNamed:@"glyphicons_195_circle_info.png"];
            img.tag = 600;
            
            [cell1.contentView addSubview:lblcurrent];
            [cell1.contentView addSubview:lbltotal];
            [cell1.contentView addSubview:img];
        }
        else
        {
            lblcurrent = (UILabel *)[cell1.contentView viewWithTag:400];
            lbltotal = (UILabel *)[cell1.contentView viewWithTag:500];
            img = (UIImageView *)[cell1.contentView viewWithTag:600];
        }
        if (indexPath.row == 0)
        {
            if (expenses > [[topArray objectAtIndex:1] doubleValue])
            {
                lblcurrent.textColor = [UIColor redColor];
                lbltotal.textColor = [UIColor redColor];
            }
        }
        if (indexPath.row == 1)
        {
            if ([[bottomArray objectAtIndex:indexPath.row] doubleValue] < 0)
            {
                lblcurrent.textColor = [UIColor redColor];
                lbltotal.textColor = [UIColor redColor];
            }
            
            lblcurrent.text = @"Current\nSavings:";
            img.image=[UIImage imageNamed:@"glyphicons_037_coins.png"];
        }

        lbltotal.text = [NSString stringWithFormat:@"$%g",[[bottomArray objectAtIndex:indexPath.row] doubleValue]];

        
        return cell1;
    }
    
    else
    {
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:SideTableCell];
        
        UILabel *lblcat = nil;
        UILabel *lblcatamount = nil;
        UIImageView *imgv = nil;
        
        if(cell2 == nil)
        {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SideTableCell];
            cell2.selectionStyle = UITableViewCellSelectionStyleGray;
            
            lblcat = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 130, 50)];
            lblcat.textColor = [UIColor redColor];
            lblcat.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblcat.text = @"Current\nExpenses:";
            lblcat.lineBreakMode = UILineBreakModeWordWrap;
            lblcat.numberOfLines = 2;
            lblcat.tag = 700;
            
            lblcatamount = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 130, 50)];
            lblcatamount.textColor = [UIColor redColor];
            lblcatamount.font = [UIFont fontWithName:@"Helvetica" size:17];
            lblcatamount.font = [UIFont boldSystemFontOfSize:17 ];
            lblcatamount.tag = 800;
            
            imgv = [[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 25, 25)];
            imgv.image=[UIImage imageNamed:@"glyphicons_195_circle_info.png"];
            imgv.tag = 900;
            
            [cell2.contentView addSubview:lblcat];
            [cell2.contentView addSubview:lblcatamount];
            [cell2.contentView addSubview:imgv];
        }
        else
        {
            lblcat = (UILabel *)[cell2.contentView viewWithTag:700];
            lblcatamount = (UILabel *)[cell2.contentView viewWithTag:800];
            imgv = (UIImageView *)[cell2.contentView viewWithTag:900];
        }
        
        BudgetCategory *bc = [catList objectAtIndex:indexPath.row];
        
        lblcat.text = bc.bcategory_name;
        imgv.image = [UIImage imageNamed:bc.bcategory_image];
        
        if (bc.category_amount > 0)
        {
            if (bc.category_spent < bc.category_amount)
            {
                lblcat.textColor = [UIColor blackColor];
                lblcatamount.textColor = [UIColor blackColor];
            }
            else
            {
                lblcat.textColor = [UIColor redColor];
                lblcatamount.textColor = [UIColor redColor];
            }
            
            lblcatamount.text = [NSString stringWithFormat:@"$%g / $%g", bc.category_spent, bc.category_amount];
        }
        else
        {
            lblcatamount.text = [NSString stringWithFormat:@"$%g", bc.category_spent];
        }
        
        return cell2;
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
    if (allowEdit)
    {
        UpdateBudgetViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateBudgetViewController"];
        [self.navigationController pushViewController:bvc animated:YES];
    }
    else
    {
        tooltip = [[CMPopTipView alloc]
                                      initWithMessage:@"Weekly Budget is only editable on start of weeks.\n(Monday & Tuesday)"] ;
        tooltip.delegate = self;
        tooltip.backgroundColor = [UIColor lightGrayColor];
        tooltip.textColor = [UIColor whiteColor];
        [tooltip presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
        
        NSTimer *timerShowToolTip;
        timerShowToolTip = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(dismissToolTip) userInfo:nil repeats:NO];
        
        //UpdateBudgetViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateBudgetViewController"];
        //[self.navigationController pushViewController:bvc animated:YES];
    }
}

- (IBAction)btnResetClicked:(id)sender
{
    NSError *error = nil;
    Database *d = [[Database alloc]init];
    NSString *dbpath = [d SetDBPath];
    
    @try {
        [[NSFileManager defaultManager] removeItemAtPath:dbpath error:&error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error: %@", error);
    }
    
    [d CreateDB];
    
    BudgetViewController *bc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
    [self.navigationController pushViewController:bc animated:YES];
}

- (void) dismissToolTip
{
    [tooltip dismissAnimated:YES];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setScroller:nil];
    [self setTopButton:nil];
    [super viewDidUnload];
}
@end

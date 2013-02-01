//
//  GoalDetailViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 30/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "GoalDetailViewController.h"
#import "Goal.h"
#import "EditGoalViewController.h"
#import "GoalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GoalDetailViewController ()
{
    Goal *g;
    NSMutableArray *goal_array;
}

@end

@implementation GoalDetailViewController

@synthesize goal_id;
@synthesize lblgoalTitle;
@synthesize lblgoalDescription;
@synthesize lblSaveWeekly;
@synthesize lblSaveTotal;
@synthesize imgView;

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
    
    lblgoalTitle.viewForBaselineLayout.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Goals"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleBack:)];
}
 
-(void)ProgressBar
{
    NSDate *today = [NSDate date];
    NSDate *startDate = [g StringToDate:g.goal_start_date];
    NSDate *lastDate = [g StringToDate:g.deadline];
    
    double totalWeeks = [g WeeksBetweenTwoDate:startDate :lastDate];
    double currentWeek = [g WeeksBetweenTwoDate:today :startDate] - 1;
    double weeksMet = g.weeks_met;
    
    NSLog(@"currenWeek: %g", currentWeek);
    NSLog(@"totalWeeks: %g", totalWeeks);
    NSLog(@"weeksMet: %g", weeksMet);
        
    /*totalWeeks = 20;
    currentWeek = 7;
    weeksMet = 4;*/
    
    if (currentWeek > totalWeeks) currentWeek = totalWeeks;
    
    double weeksNotMet = currentWeek - weeksMet;
    double weeksToGo = totalWeeks - currentWeek;
    
    if (weeksNotMet < 0) weeksNotMet = 0;
    if (weeksToGo < 0) weeksToGo = 0;
    
    double totalWidth = 280;
    double labelHeight = 35;
    double labelY = 240;
    
    double greenWidth = (weeksMet/totalWeeks)*totalWidth;
    double greyWidth = (weeksToGo/totalWeeks)*totalWidth;
    double redWidth = (weeksNotMet/totalWeeks)*totalWidth;
    double redX = 20 + greenWidth;
    
    UILabel *lblGreen;
    UILabel *lblRed;
    UILabel *lblGrey;
    
    if (greenWidth > 0)
    {
        lblGreen = [[UILabel alloc]initWithFrame:CGRectMake(20, labelY, greenWidth, labelHeight)];
        
        lblGreen.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:0 alpha:1.0];
        
        if (greenWidth > 50)
        {
            lblGreen.textColor = [UIColor whiteColor];
            lblGreen.textAlignment = NSTextAlignmentCenter;
            lblGreen.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblGreen.font = [UIFont boldSystemFontOfSize:16 ];
            lblGreen.text = [NSString stringWithFormat:@"$%g", weeksMet * g.amount_tosave];
        }
        
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:lblGreen.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(6.0, 6.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = lblGreen.bounds;
        maskLayer.path = maskPath.CGPath;
        lblGreen.layer.mask = maskLayer;
        
        [self.view addSubview:lblGreen];
        
        NSLog(@"Green Label: %g, %g, %g, %g", lblGreen.frame.origin.x, lblGreen.frame.origin.y, lblGreen.frame.size.width, lblGreen.frame.size.height);
    }
    
    if (greyWidth > 0 && (currentWeek < totalWeeks))
    {
        lblGrey = [[UILabel alloc]initWithFrame:CGRectMake(greenWidth + redWidth + 20, labelY, greyWidth, labelHeight)];
        
        lblGrey.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        
        if (greyWidth > 50)
        {
            lblGrey.textColor = [UIColor whiteColor];
            lblGrey.textAlignment = NSTextAlignmentCenter;
            lblGrey.font = [UIFont fontWithName:@"Helvetica" size:16];
            lblGrey.font = [UIFont boldSystemFontOfSize:16 ];
            lblGrey.text = [NSString stringWithFormat:@"$%d", g.goal_amount];
        }
        
        UIBezierPath *maskPath;
        
        if (greenWidth <= 0  && redWidth <= 0)
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblGrey.bounds byRoundingCorners:( UIRectCornerAllCorners) cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        else
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblGrey.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = lblGrey.bounds;
        maskLayer.path = maskPath.CGPath;
        lblGrey.layer.mask = maskLayer;
        
        [self.view addSubview:lblGrey];
        
        NSLog(@"Grey Label: %g, %g, %g, %g", lblGrey.frame.origin.x, lblGrey.frame.origin.y, lblGrey.frame.size.width, lblGrey.frame.size.height);
    }
    
    
    if (redWidth > 0)
    {        
        lblRed = [[UILabel alloc]initWithFrame:CGRectMake(redX, labelY, redWidth, labelHeight)];
        lblRed.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1.0];
        
        if (currentWeek >= totalWeeks)
        {
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblRed.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(6.0, 6.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = lblRed.bounds;
            maskLayer.path = maskPath.CGPath;
            lblRed.layer.mask = maskLayer;
        }
        
        if (greenWidth <= 0)
        {
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblRed.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(6.0, 6.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = lblRed.bounds;
            maskLayer.path = maskPath.CGPath;
            lblRed.layer.mask = maskLayer;
        }
        
        [self.view addSubview:lblRed];
        
        NSLog(@"Red Label: %g, %g, %g, %g", lblRed.frame.origin.x, lblRed.frame.origin.y, lblRed.frame.size.width, lblRed.frame.size.height);
    }
}

-(void)handleBack:(id)sender
{    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{    
    g = [[Goal alloc]init];
    goal_array = [[NSMutableArray alloc]init];
    
    for (Goal *gg in [g SelectGoal:goal_id])
    {
        [goal_array addObject:gg];
    }
    
    g = [goal_array objectAtIndex:0];
    
    NSData *imgData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:g.goal_photo]];
    imgView.image = [UIImage imageWithData:imgData];
    lblgoalTitle.text = [NSString stringWithFormat:@"  %@", g.goal_title];
    lblgoalDescription.text = g.goal_description;
    lblSaveWeekly.text = [NSString stringWithFormat:@"Save $%d Weekly!", g.amount_tosave];
    lblSaveTotal.text = [NSString stringWithFormat:@"Save $%d by %@", g.goal_amount, [self ConvertDateFormat:g.deadline]];
    
    [self ProgressBar];
}

-(NSString *)ConvertDateFormat:(NSString *)end_date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *newDate = [dateFormat dateFromString:end_date];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    return [dateFormat stringFromDate:newDate];
}


- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImgView:nil];
    [self setLblgoalTitle:nil];
    [self setLblSaveWeekly:nil];
    [self setLblSaveTotal:nil];
    [self setLblgoalDescription:nil];
    [super viewDidUnload];
}
- (IBAction)btnEdit:(id)sender
{
    EditGoalViewController *egc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditGoalViewController"];
    
    egc.goalArray = [[NSMutableArray alloc]initWithArray:goal_array];
    
    [self.navigationController pushViewController:egc animated:YES];
}
     
@end
     
     
     
     
     
     

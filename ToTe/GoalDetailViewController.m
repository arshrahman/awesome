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
@synthesize scroller;
@synthesize imageView;
@synthesize lblGoalTitle;
@synthesize lblDescription;
@synthesize lbltoSaveWeekly;
@synthesize lbltoSaveTotal;

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
 
-(void)ProgressBar
{
    NSDate *today = [NSDate date];
    NSDate *startDate = [g StringToDate:g.goal_start_date];
    NSDate *lastDate = [g StringToDate:g.deadline];
    
    double totalWeeks = [g WeeksBetweenTwoDate:startDate :lastDate];
    double currentWeek = [g WeeksBetweenTwoDate:today :startDate] - 1;
    double weeksMet = g.weeks_met;
    
    NSLog(@"Start Date: %@, Last Day: %@, currenWeek: %g", startDate, lastDate, currentWeek);
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
    double labelHeight = 32;
    double labelY = 256;
    
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
        
        if (redWidth <= 0 && greyWidth <= 0)
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblGreen.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        else
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblGreen.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(6.0, 6.0)];    
        }
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = lblGreen.bounds;
        maskLayer.path = maskPath.CGPath;
        lblGreen.layer.mask = maskLayer;
        
        [self.view addSubview:lblGreen];
        
        //NSLog(@"Green Label: %g, %g, %g, %g", lblGreen.frame.origin.x, lblGreen.frame.origin.y, lblGreen.frame.size.width, lblGreen.frame.size.height);
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
        
        //NSLog(@"Grey Label: %g, %g, %g, %g", lblGrey.frame.origin.x, lblGrey.frame.origin.y, lblGrey.frame.size.width, lblGrey.frame.size.height);
    }
    
    
    if (redWidth > 0)
    {        
        lblRed = [[UILabel alloc]initWithFrame:CGRectMake(redX, labelY, redWidth, labelHeight)];
        lblRed.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1.0];
        
        UIBezierPath *maskPath;
        
        if (currentWeek >= totalWeeks && greenWidth <= 0)
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblRed.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        else if (currentWeek >= totalWeeks)
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblRed.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        else if (greenWidth <= 0)
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:lblRed.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = lblRed.bounds;
        maskLayer.path = maskPath.CGPath;
        lblRed.layer.mask = maskLayer;
        
        [self.view addSubview:lblRed];
    }
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
    UIImage *img = [UIImage imageWithData:imgData];
 
    scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    lblGoalTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 126, 320, 35)];
    lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 280, 85)];
    lbltoSaveWeekly = [[UILabel alloc]initWithFrame:CGRectMake(0, 293, 320, 36)];
    lbltoSaveTotal = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, 320, 36)];
    
    
    imageView.image = img;
    
    [scroller setContentSize:imageView.frame.size];
    [scroller scrollRectToVisible:imageView.frame animated:YES];
    scroller.showsVerticalScrollIndicator = NO;
    scroller.showsHorizontalScrollIndicator = NO;
    //scroller.bounces = NO;
    scroller.maximumZoomScale = 2.0f;
    scroller.minimumZoomScale = 0.5f;
    
    lblDescription.numberOfLines = 4;
    lblDescription.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    lblDescription.lineBreakMode = UILineBreakModeTailTruncation;
    lblDescription.textAlignment = UITextAlignmentCenter;
    
    lbltoSaveWeekly.numberOfLines = 1;
    lbltoSaveWeekly.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    lbltoSaveWeekly.textAlignment = UITextAlignmentCenter;
    
    lbltoSaveTotal.numberOfLines = 1;
    lbltoSaveTotal.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    lbltoSaveTotal.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:scroller];
    [scroller addSubview:imageView];
    [self.view addSubview:lblGoalTitle];
    [self.view addSubview:lblDescription];
    [self.view addSubview:lbltoSaveWeekly];
    [self.view addSubview:lbltoSaveTotal];
 

    lblGoalTitle.text = [NSString stringWithFormat:@"  %@", g.goal_title];
    lblDescription.text = g.goal_description;
    lbltoSaveWeekly.text = [NSString stringWithFormat:@"Save $%d Weekly!", g.amount_tosave];
    lbltoSaveTotal.text = [NSString stringWithFormat:@"Save $%d by %@", g.goal_amount, [g ConvertDateFormat:g.deadline]];
 
    [self ProgressBar];
 
    lblGoalTitle.viewForBaselineLayout.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
}

-(void)viewDidDisappear:(BOOL)animated
{
    imageView.image = nil;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setScroller:nil];
    [self setImageView:nil];
    [self setLblGoalTitle:nil];
    [self setLblDescription:nil];
    [self setLbltoSaveWeekly:nil];
    [self setLbltoSaveTotal:nil];
}
- (IBAction)btnEdit:(id)sender
{
    EditGoalViewController *egc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditGoalViewController"];
    
    egc.goalArray = [[NSMutableArray alloc]initWithArray:goal_array];

    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:egc];
    [navC setModalPresentationStyle:UIModalTransitionStyleCrossDissolve];
    
    [self.navigationController presentViewController:navC animated:YES completion:nil];
}
      
     
@end
     
     
     
     
     
     

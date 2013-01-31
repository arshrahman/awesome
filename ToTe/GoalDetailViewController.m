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
    
    lblgoalTitle.viewForBaselineLayout.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35f];
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
     
     
     
     
     
     

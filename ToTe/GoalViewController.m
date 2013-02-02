//
//  GoalViewController.m
//  ToTe
//
//  Created by user on 3/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "GoalViewController.h"
#import "Goal.h"
#import "GoalDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GoalViewController ()
{
    NSMutableArray *goalArray;
    Goal *g;
}

@end

@implementation GoalViewController

@synthesize tblViewGoal;

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
	
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    g = [[Goal alloc]init];
    goalArray = [[NSMutableArray alloc]init];
    
    for (Goal *gg in [g SelectAllGoals])
    {
        [goalArray addObject:gg];
    }
    
    [tblViewGoal reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return goalArray.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goalTbViewCell = @"goalTbViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goalTbViewCell"];
    
    UILabel *lblname = nil;
    UILabel *lblamount = nil;
    UIImageView *imv = nil;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goalTbViewCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        lblname = [[UILabel alloc]initWithFrame:CGRectMake(63, 3, 280, 25)];
        lblname.textColor = [UIColor blackColor];
        lblname.font = [UIFont fontWithName:@"Helvetica" size:17];
        lblname.text = @"";
        lblname.tag = 100;
        
        lblamount = [[UILabel alloc]initWithFrame:CGRectMake(63, 26, 280, 25)];
        lblamount.textColor = [UIColor blackColor];
        lblamount.font = [UIFont fontWithName:@"Helvetica" size:16];
        lblamount.textColor = [UIColor darkGrayColor];
        lblamount.tag = 200;
        
        imv = [[UIImageView alloc]initWithFrame:CGRectMake(11, 10, 41, 35)];
        imv.image=[UIImage imageNamed:@"glyphicons_138_picture.png"];
        imv.layer.cornerRadius = 5.0;
        imv.clipsToBounds = YES;
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
    
    Goal *gl = [goalArray objectAtIndex:indexPath.row];
    
    lblname.text = [self TruncateString:gl.goal_title];
    lblamount.text = [NSString stringWithFormat:@"$%d/ $%d", (gl.amount_tosave * gl.weeks_met), gl.goal_amount];
    
    if ([gl.goal_photo length] > 0)
    {
        NSData *imageData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:gl.goal_photo]];
        imv.image = [UIImage imageWithData:imageData];
    }
    else
    {
        imv.frame = CGRectMake(15, 13, 30, 25);
        imv.image = [UIImage imageNamed:@"glyphicons_138_picture.png"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Goal *ggl = [goalArray objectAtIndex:indexPath.row];
    
    GoalDetailViewController *gdc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoalDetailViewController"];
    gdc.goal_id = ggl.goal_id;
    
    [self.navigationController pushViewController:gdc animated:YES];
    
}


- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

-(NSString *)TruncateString:(NSString *)string
{
    int size=[string length];
    if (size > 25)
    {
        NSMutableString *string1 = [[NSMutableString alloc]init];
        char c;
        for(int index = 0;index < 25 ;index++)
        {
            c =[string characterAtIndex:index];
            
            [string1 appendFormat:@"%c",c];
        }
        [string1 appendFormat:@"..."];
        
        string = string1;
    }
    
    return string;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTblViewGoal:nil];
    [super viewDidUnload];
}
@end

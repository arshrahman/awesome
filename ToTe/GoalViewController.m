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
#import "SettingsData.h"
#import "AppLaunch.h"
#import <QuartzCore/QuartzCore.h>

@interface GoalViewController ()
{
    NSMutableArray *goalArray;
    NSMutableArray *goalIDArray;
    Goal *g;
    BOOL editing;
    BOOL checkFB;
    BOOL checkTwitter;
    BOOL goalMet;
    BOOL postFaceBook;
    BOOL postTwitter;
}

@end

@implementation GoalViewController

@synthesize tblViewGoal;
@synthesize btnReorder;

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
    
    editing = FALSE;
}

//Twitter and facebook code
-(void)Tweet:(Goal *)goal
{
	if([SLComposeViewController  isAvailableForServiceType:SLServiceTypeTwitter] && checkTwitter == TRUE)
	{
		SLComposeViewController *twitter = [[SLComposeViewController alloc]init];
		
		twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *amount = [NSString stringWithFormat: @"%.2f", goal.goal_amount];
        
        //append budget/goal title/end date
		[twitter setInitialText:[NSString stringWithFormat:@"Hi everyone! I have decided to save $%@ for my goal, %@ by %@! Please encouraging me!", amount, goal.goal_title, goal.deadline]];
        
		[self presentViewController:twitter animated:YES completion:nil];
        
		[twitter setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             NSString *output;
             
             switch (result) {
                 case SLComposeViewControllerResultCancelled:
                     output = @"Action Cancelled";
                     break;
                 case SLComposeViewControllerResultDone:
                     output = @"Tweeted";;
                     break;
                 default:
                     break;
             }
             
             if([output isEqualToString:@"Tweeted"])
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"You have just tweeted on Twitter!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 
                 [alert show];
             }
             
             [self dismissModalViewControllerAnimated:YES];
         }];
	}
    postTwitter = TRUE;
    
}

-(void)FacebookPost:(Goal *)goal
{
	if([SLComposeViewController  isAvailableForServiceType:SLServiceTypeFacebook] && checkFB == TRUE)
	{
		SLComposeViewController *facebook = [[SLComposeViewController alloc]init];
		
		facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
		NSString *amount = [NSString stringWithFormat: @"%.2f", goal.goal_amount];
        
        //append budget/goal title/end date
		[facebook setInitialText:[NSString stringWithFormat:@"Hi everyone! I have decided to save $%@ for my goal, %@ by %@! Please support me by encouraging and reminding me!:D", amount, goal.goal_title, goal.deadline]];
        
		[self presentViewController:facebook animated:YES completion:nil];
        
		[facebook setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             NSString *output;
             
             switch (result) {
                 case SLComposeViewControllerResultCancelled:
                     output = @"Action Cancelled";
                     break;
                 case SLComposeViewControllerResultDone:
                     output = @"Posted";
                     break;
                 default:
                     break;
             }
             
             if([output isEqualToString:@"Posted"])
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"You have just posted on Facebook!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 
                 [alert show];
             }
             
             if(postTwitter == TRUE)
             {
                 [self Tweet:goal];
             }
             else
             {
                 [self dismissModalViewControllerAnimated:YES];
             }
         }];
	}
    postFaceBook = TRUE;

}

-(void)viewWillAppear:(BOOL)animated
{
    
    AppLaunch *a = [[AppLaunch alloc]init];
    
    int newGoalID = [[[NSUserDefaults standardUserDefaults]objectForKey:@"NewGoal"] integerValue];

    SettingsData *s = [[SettingsData alloc]init];
    [s getDataFromSetting];
    checkFB = s.Facebook;
    checkTwitter = s.Twitter;
    
    g = [[Goal alloc]init];
    goalArray = [[NSMutableArray alloc]init];
    goalIDArray = [[NSMutableArray alloc]init];
    
    for (Goal *gg in [g SelectAllGoals])
    {
        [goalArray addObject:gg];
        [goalIDArray addObject:[NSNumber numberWithInt:gg.goal_id]];
    }
    
    [tblViewGoal reloadData];
    
    if ([a connected])
    {
        if (newGoalID > 0)
        {
            for (int i = goalArray.count-1; i >= 0; i--)
            {
                Goal *gl = [goalArray objectAtIndex:i];
                NSLog(@"gl: %d, newgoal: %d", gl.goal_id, newGoalID);
                
                if (gl.goal_id == newGoalID)
                {
                    NSLog(@"%d", newGoalID);
                    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"NewGoal"];
                    
                    [self FacebookPost:gl];
                    
                    if(postFaceBook == TRUE)
                    {
                        [self Tweet:gl];
                    }
                    break;
                }
            }
        }

    }
    
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
        cell.showsReorderControl = YES;
        
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
    lblamount.text = [NSString stringWithFormat:@"$%g/ $%g", (gl.amount_tosave * gl.weeks_met), gl.goal_amount];
    
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

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSNumber *g_id = [goalIDArray objectAtIndex:sourceIndexPath.row];
    [goalIDArray removeObjectAtIndex:sourceIndexPath.row];
    [goalIDArray insertObject:g_id atIndex:destinationIndexPath.row];
        
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

- (IBAction)btnReorderClicked:(id)sender
{
    if (goalArray.count > 0)
    {
        if (editing)
        {
            tblViewGoal.editing = NO;
            btnReorder.title = @"Reorder";
            editing = FALSE;
            
            [g ReorderPriority:goalIDArray];
    
            /*for (int i = 0; i < goalIDArray.count; i++)
            {
                NSLog(@"Id: %d, Priority: %d", [[goalIDArray objectAtIndex:i] intValue] , i+1);
            }*/
        }
        else if(!editing)
        {
            tblViewGoal.editing = YES;
            btnReorder.title = @"Done";
            editing = TRUE;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTblViewGoal:nil];
    [self setBtnReorder:nil];
    [super viewDidUnload];
}

@end

//
//  GoalDetailViewController.h
//  ToTe
//
//  Created by Abdul Rahman on 30/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblgoalTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSaveWeekly;
@property (strong, nonatomic) IBOutlet UILabel *lblSaveTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblgoalDescription;

@property(nonatomic)int goal_id;

- (IBAction)btnEdit:(id)sender;

-(void)ProgressBar;

@end


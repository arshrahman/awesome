//
//  GoalDetailViewController.h
//  ToTe
//
//  Created by Abdul Rahman on 30/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalDetailViewController : UIViewController
{
    UIScrollView *scroller;
    UIImageView *imageView;
    UILabel *lblGoalTitle;
    UILabel *lblDescription;
    UILabel *lbltoSaveWeekly;
    UILabel *lbltoSaveTotal;
}

@property(nonatomic) UIScrollView *scroller;
@property(nonatomic) UIImageView *imageView;
@property(nonatomic) UILabel *lblGoalTitle;
@property(nonatomic) UILabel *lblDescription;
@property(nonatomic) UILabel *lbltoSaveWeekly;
@property(nonatomic) UILabel *lbltoSaveTotal;

@property(nonatomic)int goal_id;

- (IBAction)btnEdit:(id)sender;

-(void)ProgressBar;

@end


//
//  CompletedGoalsDetailViewController.h
//  ToTe
//
//  Created by Pol on 22/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedGoalsDetailViewController : UIViewController
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
@property(nonatomic) UILabel *lbltoSaveTotal;
@property(nonatomic) NSString *goalTitle;
@property(nonatomic)int goal_id;

-(void)ProgressBar;

@end

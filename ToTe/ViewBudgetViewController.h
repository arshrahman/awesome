//
//  ViewBudgetViewController.h
//  ToTe
//
//  Created by Pol on 31/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Budget;

@interface ViewBudgetViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL pageControlIsChangingPage;
}

@property (nonatomic, strong) Budget *budgetItem;
@property (nonatomic, retain)IBOutlet UITableView *topView;
@property (nonatomic, retain)IBOutlet UITableView *bottomView;
@property (nonatomic, retain)IBOutlet UITableView *sideView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *topButton;
@property (nonatomic) NSString *dateWeek;

- (IBAction)pageControl:(id)sender;
- (IBAction)btnClicked:(id)sender;


@end
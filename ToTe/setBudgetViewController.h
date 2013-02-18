//
//  setBudgetViewController.h
//  ToTe
//
//  Created by user on 3/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "CMPopTipView.h"

@interface setBudgetViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, CMPopTipViewDelegate>
{
    BOOL pageControlIsChangingPage;
    UIActivityIndicatorView *activity;
    UIView *activityView;
}

@property(nonatomic, retain)IBOutlet UITableView *topView;
@property(nonatomic, retain)IBOutlet UITableView *bottomView;
@property(nonatomic, retain)IBOutlet UITableView *sideView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *topButton;

- (IBAction)pageControl:(id)sender;
- (IBAction)btnClicked:(id)sender;
- (IBAction)btnResetClicked:(id)sender;


@end

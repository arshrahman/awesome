//
//  ByWeekViewController.h
//  ToTe
//
//  Created by Pol on 21/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByWeekViewController : UIViewController

//@property (nonatomic) IBOutlet UITableView *ByWeekUITableView;
@property (nonatomic, strong)NSMutableArray *BudgetList;

-(double)GetCurentExpenses:(int)budgetid;

@end

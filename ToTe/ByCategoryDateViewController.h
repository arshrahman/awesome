//
//  ByCategoryDateViewController.h
//  ToTe
//
//  Created by user on 26/3/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByCategoryDateViewController : UITableViewController
{
    NSMutableArray *allBudget;
    NSMutableArray *containerOfAllTheEightWeeks;
    NSMutableArray *eightWeeksBudget;
    NSMutableArray *eightWeeksBudgetDates;
    NSMutableArray *containerOfAllTheEightWeeksDates;
    NSMutableArray *eightWeekDate;
}

@property (nonatomic) int categoryID;
-(NSMutableArray *)getEightWeekBudget;
@end

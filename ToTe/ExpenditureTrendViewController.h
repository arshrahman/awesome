//
//  ExpenditureTrendViewController.h
//  ToTe
//
//  Created by user on 21/3/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenditureTrendViewController : UITableViewController
{
    NSMutableArray *allBudget;
    NSMutableArray *containerOfAllTheEightWeeks;
    NSMutableArray *eightWeeksBudget;
    NSMutableArray *Expend;
    NSMutableArray *Saving;
}

-(NSMutableArray *)getExpendAndSaving;

@end

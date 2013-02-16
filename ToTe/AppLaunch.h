//
//  AppLaunch.h
//  ToTe
//
//  Created by Abdul Rahman on 4/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLaunch : NSObject


-(void)InsertPreviousBudget;
-(NSString *)GetStartDate;
-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
-(NSMutableArray *)GetBudgetIDIncome;
-(void)GoalAchieved:(int)lastBudget_id:(int)income:(int)weeks;
-(double)GetExpensesForLastWeek:(int)lbudget_id;
-(NSString *)GetSecureUID;
-(void)PostToGoogleDocs:(NSString *)data :(NSString *)postUrl;
-(void)PrepareToPostGoogle;
-(NSMutableArray *)GetBudgetByWeeks:(int)weeks;
-(void)PostGoals:(int)weeks;
-(NSString *)GetMonday;
-(void)PostAllExpenses:(int)weeks;


@end

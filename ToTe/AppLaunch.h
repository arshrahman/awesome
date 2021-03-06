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
-(void)GoalAchieved:(int)lastBudget_id:(double)income:(int)weeks;
-(double)GetExpensesForLastWeek:(int)lbudget_id;
-(NSString *)GetSecureUID;
-(BOOL)PostToGoogleDocs:(NSString *)data :(NSString *)postUrl;
-(BOOL)PrepareToPostGoogle:(int)weeks;
-(void)PostBudgets:(int)weeks:(NSString *)userId;
-(void)PostGoals:(NSString *)userId;
-(NSString *)GetMonday;
-(void)PostExpenses:(int)weeks:(NSString *)userId;
-(BOOL)connected;
-(int)ShouldPostToGoogle;

@end

//
//  Budget.h
//  ToTe
//
//  Created by Abdul Rahman on 17/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Budget : NSObject

@property(nonatomic)int budget_id;
@property(nonatomic)NSString *startDate;
@property(nonatomic)NSString *endDate;
@property(nonatomic)double budget_amount;
@property(nonatomic)double wincome;

- (NSMutableArray*)GetDate;
- (int)InsertBudget:(double)budgetAmount :(double)wkIncome;
- (BOOL)InsertBudgetCategories:(NSMutableArray *)catList;
- (NSMutableArray *)GetIncomeBudget;
- (double)GetExpenses;
- (int)GetMaxBudgetID;
- (NSMutableArray *)GetBudgetCategories;
- (NSMutableArray *)SelectAllBudgetCategories;
- (void)UpdateBudget:(double)budgetAmount :(double)wkIncome;
- (void)DeleteBudgetCategories;

@end

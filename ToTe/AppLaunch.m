//
//  AppLaunch.m
//  ToTe
//
//  Created by Abdul Rahman on 4/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "AppLaunch.h"
#import "sqlite3.h"
#import "Database.h"

@implementation AppLaunch
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    Database *d;
}

- (void)InsertPreviousBudget
{
    NSString *nslast_date;
    
    if(dbPathString == NULL)
    {
        d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT START_DATE FROM BUDGET WHERE BUDGET_ID=(SELECT MAX(BUDGET_ID) FROM BUDGET)"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                nslast_date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                //NSLog(@"date: %@", nslast_date);
            }
        }
        else
        {
            NSLog(@"Hi InsertPreviousBudget!");
        }
        sqlite3_finalize(statement);
        
        if ( [nslast_date length] > 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            //NSDate *last_date = [[NSDate alloc]init];
            NSDate *last_date = [dateFormatter dateFromString:nslast_date];
            //NSLog(@"Last day: %@", last_date);
            
            NSDate *today = [[NSDate alloc]init];
            //today = [NSDate date];
            //NSLog(@"Today: %@", today);
            
            if (today > last_date)
            {
                int days = [self daysBetweenDate:last_date andDate:today];
                int weeks = 0;
                
                if (days > 6)
                {
                    weeks = ceil(days/7);
                    
                    char *error;
                    int maxId = 0;
                    maxId = self.GetMaxBudgetID;
                    
                    NSString *inst_stmt = @"";
                    
                    for (int i = 1; i <= weeks; i++)
                    {
                        NSString *temp = [NSString stringWithFormat:@"INSERT INTO BUDGET (START_DATE, END_DATE, BUDGET_AMOUNT, WINCOME) SELECT DATETIME(START_DATE, '+%d DAYS') AS START_DATE, DATETIME(END_DATE, '+%d DAYS') AS END_DATE, BUDGET_AMOUNT, WINCOME FROM BUDGET WHERE BUDGET_ID = %d; INSERT INTO BUDGET_CATEGORY (BUDGET_ID, CATEGORY_ID, CATEGORY_AMOUNT)  SELECT %d, CATEGORY_ID, CATEGORY_AMOUNT FROM BUDGET_CATEGORY WHERE BUDGET_ID = %d;", (i*7), (i*7), maxId, (maxId+i), maxId];
                        inst_stmt = [inst_stmt stringByAppendingString:temp];
                    }
                    
                    //NSLog(@"query %@", inst_stmt);
                    
                    const char *insert_stmt = [inst_stmt UTF8String];
                    
                    @try
                    {
                        sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error);
                    }
                    @catch (NSException *exception)
                    {
                        NSLog(@"Error: %s", error);
                        NSLog(@"Exception %@", exception);
                    }
                    
                    int lastWeekBudgetId = maxId-1;
                    NSLog(@"Last Week's Budget Id: %d", lastWeekBudgetId);
                    
                    [self GoalAchieved:lastWeekBudgetId];
                }
                //NSLog(@"days: %d, weeks: %d", days, weeks);
            }
        }
    }
    sqlite3_close(budgetDB);
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    int daysToMinus = 0;
    int weekday = 0;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:toDateTime];
    weekday = [comps weekday];
    
    if (weekday == 1)
    {
        daysToMinus = 6;
    }
    else if (weekday > 2)
    {
        daysToMinus = weekday - 2;
    }
    //NSLog(@"days to minus: %d", daysToMinus);
    
    NSTimeInterval distanceBetweenDates = [toDateTime timeIntervalSinceDate:fromDateTime];
    NSInteger minutes = distanceBetweenDates / 60;
    
    NSInteger days = minutes/1440;
    
    if (minutes < 1440 && minutes%1440)
    {
        days += 1;
    }
    
    return days - daysToMinus;
}

-(int)GetMaxBudgetID
{
    int maxId = 0;
    
    sqlite3_stmt *st;
    const char *queryMaxId = "SELECT MAX(BUDGET_ID) FROM BUDGET";
    
    if (sqlite3_prepare(budgetDB, queryMaxId, -1, &st, NULL)==SQLITE_OK)
    {
        if (sqlite3_step(st)==SQLITE_ROW)
        {
            maxId = sqlite3_column_int(st, 0);
        }
    }
    sqlite3_finalize(st);
    
    return maxId;
}

/*-(int)GetLastWeekBudgetID
{
    int b_id = 0;
    sqlite3_stmt *st;
    const char *queryId = "SELECT MAX(BUDGET_ID)-1 FROM BUDGET";
    
    if (sqlite3_prepare(budgetDB, queryId, -1, &st, NULL)==SQLITE_OK)
    {
        if (sqlite3_step(st)==SQLITE_ROW)
        {
            b_id = sqlite3_column_int(st, 0);
        }
    }
    sqlite3_finalize(st);
    
    return b_id;
}*/


-(double)GetLastWeekIncome:(int)bId
{
    double wincome = 0;
    sqlite3_stmt *st;
    
    NSString *queryIncome = [NSString stringWithFormat:@"SELECT WINCOME FROM BUDGET WHERE BUDGET_ID = %d", bId];
    const char *query_income = [queryIncome UTF8String];
    
    if (sqlite3_prepare(budgetDB, query_income, -1, &st, NULL)==SQLITE_OK)
    {
        if (sqlite3_step(st)==SQLITE_ROW)
        {
            wincome = sqlite3_column_int(st, 0);
        }
    }
    sqlite3_finalize(st);
    
    return wincome;
}


-(double)GetSavingsForLastWeek:(int)lbudget_id
{
    double savings = 0;
    int lastWeekBudgetId = 0;
    double expenses = 0;
    double wincome = 0;
    
    lastWeekBudgetId = lbudget_id;
    wincome = [self GetLastWeekIncome:lastWeekBudgetId];
    
    sqlite3_stmt *statement;
    NSString *query = [NSString stringWithFormat:@"SELECT SUM(X.EXPENSE) FROM (SELECT SUM(S.SHOPPING_TOTAL) AS EXPENSE FROM SHOPPING_LIST S WHERE S.BUDGET_ID = %d UNION SELECT SUM(P.PURCHASE_ITEM_PRICE) AS EXPENSE FROM PURCHASE P WHERE P.BUDGET_ID = %d)X", lastWeekBudgetId, lastWeekBudgetId];
    
    const char *query_sql = [query UTF8String];
    
    if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            expenses = sqlite3_column_double(statement, 0);
        }
    }
    else
    {
        NSLog(@"Got error in getting last week's savings");
    }
    sqlite3_finalize(statement);
    
    savings = wincome - expenses;
    
    return savings;
}


-(void)GoalAchieved:(int)lastBudget_id
{
    char *error;
    int savings = 0;
    BOOL goalsMet = FALSE;
    NSString *delimiter = @"";
    
    if(dbPathString == NULL)
    {
        d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        savings = [self GetSavingsForLastWeek:lastBudget_id];
        NSLog(@"Savings: %d", savings);
        
        if (savings > 0)
        {
            sqlite3_stmt *statement;
            const char *query_sql = "SELECT GOAL_ID, AMOUNT_TOSAVE FROM GOAL ORDER BY PRIORITY";
            
            if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
            {
                NSString *queryWeeksMet = @"UPDATE GOAL SET WEEKS_MET = COALESCE(WEEKS_MET, 0) + 1 WHERE GOAL_ID IN (";
                
                while (sqlite3_step(statement)==SQLITE_ROW)
                {
                    int toSave = sqlite3_column_int(statement, 1);
                    
                    if (savings >= toSave)
                    {
                        queryWeeksMet = [queryWeeksMet stringByAppendingString:[NSString stringWithFormat:@"%@%d", delimiter, sqlite3_column_int(statement, 0)]];
                        
                        delimiter = @", ";
                        savings -= toSave;
                        goalsMet = TRUE;
                    }
                }
                
                queryWeeksMet = [queryWeeksMet stringByAppendingString:@")"];
                NSLog(@"Query: %@", queryWeeksMet);
                
                if (goalsMet)
                {
                    const char *weeksMet_stmt = [queryWeeksMet UTF8String];
                    
                    @try
                    {
                        sqlite3_exec(budgetDB, weeksMet_stmt, NULL, NULL, &error);
                    }
                    @catch (NSException *exception)
                    {
                        NSLog(@"Error: %s", error);
                        NSLog(@"Exception %@", exception);
                    }
                }
            }
            else
            {
                NSLog(@"Got error in getting last week's savings");
            }
            sqlite3_finalize(statement);
        }
    }
}


@end

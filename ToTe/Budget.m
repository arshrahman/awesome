//
//  Budget.m
//  ToTe
//
//  Created by Abdul Rahman on 17/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "Budget.h"
#import "Database.h"
#import "sqlite3.h"
#import "BudgetCategory.h"

@implementation Budget
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
}

-(NSMutableArray*)GetDate
{
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:today];
    
    [nowComponents setWeekday:2];
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    NSDate *monday = [calendar dateFromComponents:nowComponents];
    NSLog(@"Monday: %@", monday);
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 6;
    dayComponent.hour = 23;
    dayComponent.minute = 59;
    dayComponent.second = 59;
    
    NSDate *sunday = [calendar dateByAddingComponents:dayComponent toDate:monday options:0];
    NSLog(@"Sunday: %@", sunday);

    [dates addObject:monday];
    [dates addObject:sunday];
        
    return dates;
}

- (int)InsertBudget:(double)budgetAmount :(double)wkIncome
{
    char *error;
    int rowID = 0;
    Database *d = [[Database alloc]init];
    dbPathString = [d SetDBPath];
    
    NSMutableArray *dates = [self GetDate];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO BUDGET(START_DATE, END_DATE, BUDGET_AMOUNT, WINCOME) VALUES ('%@','%@','%2f', '%f')",[dates objectAtIndex:0], [dates objectAtIndex:1], budgetAmount, wkIncome];
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            rowID = sqlite3_last_insert_rowid(budgetDB);
            NSLog(@"id: %d", rowID);
        }
        sqlite3_close(budgetDB);
    }
    return rowID;
}

-(BOOL)InsertBudgetCategories:(NSMutableArray *)catList:(int)budgetID
{
    char *error;
    bool result = false;
    
    Database *d = [[Database alloc]init];
    dbPathString = [d SetDBPath];
    
    NSString *inst_stmt = @"";
    
    for(BudgetCategory *bc in catList)
    {
        NSString *temp = [NSString stringWithFormat:@"INSERT INTO BUDGET_CATEGORY(BUDGET_ID, CATEGORY_ID, CATEGORY_AMOUNT) VALUES (%d,%d,%d);",budgetID, bc.category_id, bc.category_amount];
        inst_stmt = [inst_stmt stringByAppendingString:temp];
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        const char *insert_stmt = [inst_stmt UTF8String];
        
        @try
        {
            sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error);
            result = true;
        }
        @catch (NSException *exception)
        {
            NSLog(@"Error: %s", error);
            NSLog(@"Exception %@", exception);
        }
        @finally
        {
            sqlite3_close(budgetDB);
        }
    }
    
    return result;
}

-(NSMutableArray *)GetIncomeBudget
{
    NSMutableArray *incomeBudget = [[NSMutableArray alloc]init];
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT WINCOME, BUDGET_AMOUNT FROM BUDGET WHERE BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET)"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                NSNumber *income = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                NSNumber *budget = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                
                [incomeBudget addObject:income];
                [incomeBudget addObject:budget];
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
    }
    
    return incomeBudget;
}

-(double)GetExpenses
{
    double expenses = 0;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT SUM(X.EXPENSE) FROM (SELECT SUM(S.SHOPPING_TOTAL) AS EXPENSE FROM SHOPPING_LIST S WHERE S.BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET) UNION SELECT SUM(P.PURCHASE_ITEM_PRICE) AS EXPENSE FROM PURCHASE P WHERE P.BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET))X"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                expenses = sqlite3_column_double(statement, 0);
                NSLog(@"expenses: %f", expenses);
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
    }
    return expenses;
}

-(NSMutableArray *)GetBudgetCategories
{
    NSMutableArray *budgetCategories = [[NSMutableArray alloc]init];
    int maxId = 0;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *st;
        const char *queryMaxId = "SELECT MAX(BUDGET_ID) FROM BUDGET";
        
        if (sqlite3_prepare(budgetDB, queryMaxId, -1, &st, NULL)==SQLITE_OK)
        {            
            if (sqlite3_step(st)==SQLITE_ROW)
            {
                maxId = sqlite3_column_int(st, 0);
            }
        }
        
        /*query
        SELECT X.CATEGORY_ID, X.CATEGORY_NAME, X.CATEGORY_IMAGE, SUM(X.CATEGORY_SPENT), CATEGORY_AMOUNT FROM (SELECT C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_IMAGE, SUM(I.SHOPPING_ITEM_PRICE) AS CATEGORY_SPENT, '' AS CATEGORY_AMOUNT FROM SHOPPING_ITEM I, CATEGORY C, SHOPPING_LIST L WHERE C.CATEGORY_ID = I.CATEGORY_ID AND I.SHOPPING_ID = L.SHOPPING_ID AND L.BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET) GROUP BY C.CATEGORY_ID UNION SELECT C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_IMAGE, SUM(P.PURCHASE_ITEM_PRICE) AS CATEGORY_SPENT, '' AS CATEGORY_AMOUNT FROM PURCHASE P, CATEGORY C WHERE C.CATEGORY_ID = P.CATEGORY_ID AND P.BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET) GROUP BY C.CATEGORY_ID UNION SELECT C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_IMAGE, '' AS CATEGORY_SPENT, BC.CATEGORY_AMOUNT FROM CATEGORY C, BUDGET_CATEGORY BC WHERE C.CATEGORY_ID = BC.CATEGORY_ID AND BC.BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET)) X GROUP BY X.CATEGORY_ID ORDER BY X.CATEGORY_AMOUNT
        */
        
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT X.CATEGORY_ID, X.CATEGORY_NAME, X.CATEGORY_IMAGE, SUM(X.CATEGORY_SPENT), CATEGORY_AMOUNT FROM (SELECT C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_IMAGE, SUM(I.SHOPPING_ITEM_PRICE) AS CATEGORY_SPENT, '' AS CATEGORY_AMOUNT FROM SHOPPING_ITEM I, CATEGORY C, SHOPPING_LIST L WHERE C.CATEGORY_ID = I.CATEGORY_ID AND I.SHOPPING_ID = L.SHOPPING_ID AND L.BUDGET_ID = %d GROUP BY C.CATEGORY_ID UNION SELECT C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_IMAGE, SUM(P.PURCHASE_ITEM_PRICE) AS CATEGORY_SPENT, '' AS CATEGORY_AMOUNT FROM PURCHASE P, CATEGORY C WHERE C.CATEGORY_ID = P.CATEGORY_ID AND P.BUDGET_ID = %d GROUP BY C.CATEGORY_ID UNION SELECT C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_IMAGE, '' AS CATEGORY_SPENT, BC.CATEGORY_AMOUNT FROM CATEGORY C, BUDGET_CATEGORY BC WHERE C.CATEGORY_ID = BC.CATEGORY_ID AND BC.BUDGET_ID = %d) X GROUP BY X.CATEGORY_ID ORDER BY X.CATEGORY_AMOUNT;", maxId, maxId, maxId];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                BudgetCategory *bc = [[BudgetCategory alloc]init];
                
                bc.category_id = sqlite3_column_int(statement, 0);
                [bc setBcategory_name:[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                bc.bcategory_image = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                bc.category_spent = sqlite3_column_double(statement, 3);
                bc.category_amount = sqlite3_column_double(statement, 4);
                
                [budgetCategories addObject:bc];
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
    }
    return budgetCategories;
}


@end

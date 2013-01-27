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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
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

    [dates addObject:[formatter stringFromDate:monday]];
    [dates addObject:[formatter stringFromDate:sunday]];
        
    return dates;
}

- (int)InsertBudget:(double)budgetAmount :(double)wkIncome
{
    char *error;
    int rowID = 0;
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    NSMutableArray *dates = [self GetDate];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO BUDGET(START_DATE, END_DATE, BUDGET_AMOUNT, WINCOME) VALUES ('%@','%@','%g', '%g')",[dates objectAtIndex:0], [dates objectAtIndex:1], budgetAmount, wkIncome];
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

-(BOOL)InsertBudgetCategories:(NSMutableArray *)catList
{
    char *error;
    int maxId = 0;
    bool result = false;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
        
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        maxId = self.GetMaxBudgetID;
        
        NSString *inst_stmt = @"";
        
        for(BudgetCategory *bc in catList)
        {
            NSString *temp = [NSString stringWithFormat:@"INSERT INTO BUDGET_CATEGORY(BUDGET_ID, CATEGORY_ID, CATEGORY_AMOUNT) VALUES (%d,%d,%f);",maxId, bc.category_id, bc.category_amount];
            inst_stmt = [inst_stmt stringByAppendingString:temp];
        }
        
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
                NSNumber *income = [NSNumber numberWithDouble:sqlite3_column_double(statement, 0)];
                NSNumber *budget = [NSNumber numberWithDouble:sqlite3_column_double(statement, 1)];
                
                [incomeBudget addObject:income];
                [incomeBudget addObject:budget];
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(budgetDB);
    
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
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(budgetDB);
    
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
        maxId = self.GetMaxBudgetID;
        
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
        sqlite3_finalize(statement);
    }
    sqlite3_close(budgetDB);
    
    return budgetCategories;
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

-(NSMutableArray *)SelectAllBudgetCategories
{
    NSMutableArray *bgCategories = [[NSMutableArray alloc]init];
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {        
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT BC.BUDGET_CATEGORY_ID, BC.CATEGORY_AMOUNT, C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_IMAGE  FROM BUDGET_CATEGORY BC, CATEGORY C WHERE BC.CATEGORY_ID = C.CATEGORY_ID AND BC.BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET)"];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                BudgetCategory *bc = [[BudgetCategory alloc]init];
                
                //bc.budgetCategory_id = sqlite3_column_int(statement, 0);
                bc.category_amount = sqlite3_column_double(statement, 1);
                bc.category_id = sqlite3_column_int(statement, 2);
                bc.bcategory_name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                bc.bcategory_image = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                [bgCategories addObject:bc];
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(budgetDB);
    
    return bgCategories;
}

- (void)UpdateBudget:(double)budgetAmount :(double)wkIncome
{
    char *error;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *updateStmt = [NSString stringWithFormat:@"UPDATE BUDGET SET BUDGET_AMOUNT = '%g', WINCOME = '%g' WHERE BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET)", budgetAmount, wkIncome];
        const char *update_stmt = [updateStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, update_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Updated!");
        }
        sqlite3_close(budgetDB);
    }
}

- (void)DeleteBudgetCategories
{
    char *error;

    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        const char *delete_stmt = "DELETE FROM BUDGET_CATEGORY WHERE BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET)";
        
        if (sqlite3_exec(budgetDB, delete_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Deleted!");
        }
        sqlite3_close(budgetDB);
    }
}

- (void)InsertPreviousBudget
{
    NSString *nslast_date;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT END_DATE FROM BUDGET WHERE BUDGET_ID=(SELECT MAX(BUDGET_ID) FROM BUDGET)"];
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
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            NSDate *last_date = [[NSDate alloc] init];
            last_date = [dateFormatter dateFromString:nslast_date];
            NSLog(@"date1: %@", last_date);
            
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
            
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            NSDate *today = [dateFormatter dateFromString:strDate];
            NSLog(@"today: %@", today);
            
            int days = [self daysBetweenDate:last_date andDate:today];
            int weeks = 0;
            
            if (days > 6)
            {
                weeks = ceil(days/7);
                
                if (ceil(days%7) > 0) 
                {
                    weeks += 1;
                }
                
                char *error;
                int maxId = 0;
                maxId = self.GetMaxBudgetID;
                
                NSString *inst_stmt = @"";
                
                for (int i = 1; i <= weeks; i++)
                {
                    NSString *temp = [NSString stringWithFormat:@"INSERT INTO BUDGET (START_DATE, END_DATE, BUDGET_AMOUNT, WINCOME) SELECT DATETIME(START_DATE, '+%d DAYS') AS START_DATE, DATETIME(END_DATE, '+%d DAYS') AS END_DATE, BUDGET_AMOUNT, WINCOME FROM BUDGET WHERE BUDGET_ID = %d; INSERT INTO BUDGET_CATEGORY (BUDGET_ID, CATEGORY_ID, CATEGORY_AMOUNT)  SELECT %d, CATEGORY_ID, CATEGORY_AMOUNT FROM BUDGET_CATEGORY WHERE BUDGET_ID = %d;", (i*7), (i*7), maxId, (maxId+i), maxId];
                    inst_stmt = [inst_stmt stringByAppendingString:temp];
                }
                
                NSLog(@"query %@", inst_stmt);
                
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
                
            }
            
            NSLog(@"days: %d, weeks: %d", days, weeks);
        }
        
    }
    sqlite3_close(budgetDB);

}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{   
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end

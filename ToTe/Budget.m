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
    NSLog(@"insert query: %@", inst_stmt);
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        const char *insert_stmt = [inst_stmt UTF8String];
        
        @try
        {
            sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error);
            result = true;
            NSLog(@"error: %s", error);
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
    char *error;
    NSMutableArray *incomeBudget = [[NSMutableArray alloc]init];
    
    Database *d = [[Database alloc]init];
    dbPathString = d.SetDBPath;
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT BUDGET_AMOUNT, WINCOME FROM BUDGET"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                
                int column = sqlite3_column_int(statement, 0);
                NSString *h = @"he";
                [incomeBudget addObject:h];
                NSLog(@"column : %d", column);
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
    }
}


@end

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
#import "SecureUDID.h"

@interface NSURLRequest (DummyInterface)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end


@implementation AppLaunch
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    Database *d;
}

- (void)InsertPreviousBudget
{
    NSString *nslast_date = @"";
    NSString *inst_stmt = @"";
    int days = 0;
    int weeks = 0;
    int maxId = 0;
    char *error;
    NSMutableArray *budgetArray;
    
    if(dbPathString == NULL)
    {
        d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        nslast_date = [self GetStartDate];
        
        if ( [nslast_date length] > 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *last_date = [dateFormatter dateFromString:nslast_date];
            NSDate *today = [[NSDate alloc]init];
            //NSLog(@"Last Start Date: %@", last_date);
            //NSLog(@"Today: %@", today);
            
            if (today > last_date)
            {
                days = [self daysBetweenDate:last_date andDate:today];
                
                if (days > 6)
                {
                    weeks = ceil(days/7);
                    budgetArray = [[NSMutableArray alloc]initWithArray:[self GetBudgetIDIncome]];
                    maxId = [[budgetArray objectAtIndex:0] intValue];
                    
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
                    
                    [self GoalAchieved:maxId:[[budgetArray objectAtIndex:1] intValue]:weeks];
                    //NSLog(@"Last Week's Budget Id: %d", maxId);
                    
                    [self PostBudget:weeks];
                    
                }
                //NSLog(@"days: %d, weeks: %d", days, weeks);
            }
        }
    }
    sqlite3_close(budgetDB);
}


-(NSString *)GetStartDate
{
    NSString *last_date;
    sqlite3_stmt *statement;
    
    const char *query_sql = "SELECT START_DATE FROM BUDGET WHERE BUDGET_ID=(SELECT MAX(BUDGET_ID) FROM BUDGET)";
    
    if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            last_date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            //NSLog(@"Last Start date: %@", last_date);
        }
    }
    else
    {
        NSLog(@"Error in Get StartDate!");
    }
    sqlite3_finalize(statement);
    
    return last_date;
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
    
    NSTimeInterval distanceBetweenDates = [toDateTime timeIntervalSinceDate:fromDateTime];
    NSInteger minutes = distanceBetweenDates / 60;
    
    NSInteger days = minutes/1440;
    
    if (minutes < 1440 && minutes%1440)
    {
        days += 1;
    }
    
    return days - daysToMinus;
}


-(NSMutableArray *)GetBudgetIDIncome
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    sqlite3_stmt *st;
    const char *queryMaxId = "SELECT BUDGET_ID, WINCOME FROM BUDGET WHERE BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET)";
    
    if (sqlite3_prepare(budgetDB, queryMaxId, -1, &st, NULL)==SQLITE_OK)
    {
        if (sqlite3_step(st)==SQLITE_ROW)
        {
            [array addObject:[NSNumber numberWithInt:sqlite3_column_int(st, 0)]];
            [array addObject:[NSNumber numberWithInt:sqlite3_column_int(st, 1)]];
        }
    }
    sqlite3_finalize(st);
    
    //NSLog(@"Budget Id: %d, Income: %d", [[array objectAtIndex:0] intValue], [[array objectAtIndex:1] intValue]);
    
    return array;
}


-(void)GoalAchieved:(int)lastBudget_id:(int)income:(int)weeks
{
    char *error;
    int savings = 0;
    int expenses = 0;
    BOOL goalsMet = FALSE;
    NSString *delimiter = @"";
    
    if(dbPathString == NULL)
    {
        d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        expenses = [self GetExpensesForLastWeek:lastBudget_id];
        savings = income - expenses;
        //NSLog(@"Savings: %d", savings);
        
        if (savings > 0)
        {
            sqlite3_stmt *statement;
            const char *query_sql = "SELECT GOAL_ID, AMOUNT_TOSAVE FROM GOAL ORDER BY PRIORITY";
            
            if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
            {
                NSString *queryWeeksMet = [NSString stringWithFormat:@"UPDATE GOAL SET WEEKS_MET = COALESCE(WEEKS_MET, 0) + %d WHERE GOAL_ID IN (", weeks];
                
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
                //NSLog(@"Query: %@", queryWeeksMet);
                
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


-(double)GetExpensesForLastWeek:(int)lbudget_id
{
    double expenses = 0;
    
    sqlite3_stmt *statement;
    NSString *query = [NSString stringWithFormat:@"SELECT SUM(X.EXPENSE) FROM (SELECT SUM(S.SHOPPING_TOTAL) AS EXPENSE FROM SHOPPING_LIST S WHERE S.BUDGET_ID = %d UNION SELECT SUM(P.PURCHASE_ITEM_PRICE) AS EXPENSE FROM PURCHASE P WHERE P.BUDGET_ID = %d)X", lbudget_id, lbudget_id];
    
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
    
    return expenses;
}


-(void)PostBudget:(int)weeks
{
    //NSString *userId = [self GetSecureUID];
    
    
}


-(NSString *)GetSecureUID
{
    NSString *domain = NSBundle.mainBundle.infoDictionary[@"CFBundleIdentifier"];
    NSString *key        = @"arshrahmanPolhusayZarakukayo";
    NSString *identifier = [SecureUDID UDIDForDomain:domain usingKey:key];
    
    NSLog(@"id: %@", identifier);
    
    return identifier;
}


-(void)PostToGoogleDocs
{
    NSString *post = @"entry.1=Hannan&entry.2=Affan";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    //NSURL *url = [NSURL URLWithString:@"https://docs.google.com/forms/d/1AoPxG5hQEUaxnPN-RJwmL3sk6YxdtijO7LkFfYAuS3E/formResponse"];
    NSURL *url = [NSURL URLWithString:@"https://docs.google.com/forms/d/1Vg-q9TeKA03dP2atPg_tz9SAI5zRhqXvWtdDJDcyWF0/formResponse"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",data);
}


@end












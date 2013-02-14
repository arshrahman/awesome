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
#import "Budget.h"
#import "BudgetCategory.h"
#import "Goal.h"
#import "Purchase.h"

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
                        
                        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:weeks] forKey:@"Weeks"];
                        
                        [self GoalAchieved:maxId:[[budgetArray objectAtIndex:1] intValue]:weeks];
                                                
                        [self PostBudget];
                    }
                    @catch (NSException *exception)
                    {
                        NSLog(@"Error: %s", error);
                        NSLog(@"Exception %@", exception);
                    }
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


-(void)PostBudget
{
    NSString *ns = [[NSUserDefaults standardUserDefaults]objectForKey:@"Weeks"];
    int weeks = [ns intValue];
    
    if (weeks > 0)
    {
        NSString *userId = [self GetSecureUID];
        
        NSString *postData = [NSString stringWithFormat:@"entry.152079890=%@&entry.2099356811=startdate&entry.1090870720=weeklyIncome&entry.58372674=totalbudget&entry.887497858=totalExenses&entry.1309306391=budgetClothes&entry.763272716=budgetFood&entry.1367868194=budgetEntertainment&entry.1886459060=budgetNecessities&entry.169362762=budgetTransport&entry.1285347822=budgetOthers&entry.685118874=ExpensesClothes&entry.717710273=ExpensesFood&entry.1955738301=ExpensesEntertainment&entry.26182424=ExpensesNecessities&entry.426598365=ExpensesTransport&entry.1028591383=ExpensesOthers", userId];
        
        NSString *postUrl = @"https://docs.google.com/forms/d/1HYdL3f7O9mU0X1g1xbBG4wvPU2-oZRHTmhYK8404Hqg/formResponse";
        
        [self PostToGoogleDocs:postData :postUrl];
        
    }
}


-(NSString *)GetSecureUID
{
    NSString *domain = NSBundle.mainBundle.infoDictionary[@"CFBundleIdentifier"];
    NSString *key        = @"arshrahmanPolhusayZarakukayo";
    NSString *identifier = [SecureUDID UDIDForDomain:domain usingKey:key];
    
    //NSLog(@"id: %@", identifier);
    
    return identifier;
}

-(NSMutableArray *)GetBudgetByWeeks:(int)weeks
{
    NSMutableArray *allBudget = [[NSMutableArray alloc]init];
    NSString *userId = [self GetSecureUID];
    
    if(dbPathString == NULL)
    {
        d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *st;
        NSString *budgetQuery = [NSString stringWithFormat:@"SELECT BUDGET_ID, START_DATE, WINCOME, BUDGET_AMOUNT FROM BUDGET ORDER BY BUDGET_ID  DESC LIMIT 1, %d", weeks];
        const char *budget_query = [budgetQuery UTF8String];
        
        if (sqlite3_prepare(budgetDB, budget_query, -1, &st, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(st)==SQLITE_ROW)
            {
                NSMutableArray *ar = [[NSMutableArray alloc]init];
                
                [ar addObject:[NSNumber numberWithInt:sqlite3_column_int(st, 0)]];
                [ar addObject:[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(st, 1)]];
                [ar addObject:[NSNumber numberWithInt:sqlite3_column_int(st, 2)]];
                [ar addObject:[NSNumber numberWithInt:sqlite3_column_int(st, 3)]];
                
                [allBudget addObject:ar];
            }
        }
        sqlite3_finalize(st);
        
        NSString *expensesQuery = [NSString stringWithFormat:@"SELECT * FROM (SELECT BUDGET_ID, SUM(X.EXPENSE) AS EXPENSE FROM (SELECT BUDGET_ID, '' AS EXPENSE FROM BUDGET UNION SELECT S.BUDGET_ID, SUM(S.SHOPPING_TOTAL) AS EXPENSE FROM SHOPPING_LIST S GROUP BY S.BUDGET_ID UNION SELECT P.BUDGET_ID, SUM(P.PURCHASE_ITEM_PRICE) AS EXPENSE FROM PURCHASE P GROUP BY P.BUDGET_ID) X GROUP BY X.BUDGET_ID ORDER BY X.BUDGET_ID DESC LIMIT 1, %d) ORDER BY BUDGET_ID ASC", weeks];
        
        const char *expenses_query = [expensesQuery UTF8String];

        if (sqlite3_prepare(budgetDB, expenses_query, -1, &st, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(st)==SQLITE_ROW)
            {
                for (int i = 0; i < allBudget.count; i++)
                {
                    NSMutableArray *array = [allBudget objectAtIndex:i];

                    if ([[array objectAtIndex:0] intValue] == sqlite3_column_int(st, 0))
                    {
                        NSString *expense = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(st, 1)];
                        
                        if (array.count == 4)
                        {
                            [array addObject:expense];   
                        }
                    }
                }
            }
        }
        sqlite3_finalize(st);
        
        for (int i = 0; i < allBudget.count; i++)
        {
            NSMutableArray *ray = [allBudget objectAtIndex:i];
            int b_id = [[ray objectAtIndex:0] intValue];
            
            NSString * categoriesQuery = [NSString stringWithFormat:@"SELECT Y.CATEGORY_ID, CATEGORY_AMOUNT, SUM(Y.CATEGORY_SPENT) FROM (SELECT C.CATEGORY_ID, '' AS CATEGORY_SPENT, BC.CATEGORY_AMOUNT FROM CATEGORY C, BUDGET_CATEGORY BC WHERE C.CATEGORY_ID = BC.CATEGORY_ID AND BC.BUDGET_ID = %d UNION SELECT X.CATEGORY_ID, SUM(X.CATEGORY_SPENT), '' FROM (SELECT CATEGORY_ID, '' AS CATEGORY_SPENT, '' FROM CATEGORY UNION SELECT C.CATEGORY_ID,  SUM(I.SHOPPING_ITEM_PRICE) AS CATEGORY_SPENT, '' FROM SHOPPING_ITEM I, CATEGORY C, SHOPPING_LIST L WHERE C.CATEGORY_ID = I.CATEGORY_ID AND I.SHOPPING_ID = L.SHOPPING_ID AND L.BUDGET_ID = %d GROUP BY C.CATEGORY_ID UNION SELECT C.CATEGORY_ID,  SUM(P.PURCHASE_ITEM_PRICE) AS CATEGORY_SPENT, '' FROM PURCHASE P, CATEGORY C WHERE C.CATEGORY_ID = P.CATEGORY_ID AND P.BUDGET_ID = %d GROUP BY C.CATEGORY_ID) X GROUP BY X.CATEGORY_ID) Y GROUP BY Y.CATEGORY_ID", b_id, b_id, b_id];
            
            const char *categories_query = [categoriesQuery UTF8String];
            
            if (sqlite3_prepare(budgetDB, categories_query, -1, &st, NULL)==SQLITE_OK)
            {
                while (sqlite3_step(st)==SQLITE_ROW)
                {
                    NSString *c_amount = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(st, 1)];
                    NSString *c_spent = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(st, 2)];
                    
                    if ([c_amount isEqualToString:@""])
                    {
                        c_amount = @"0.0";
                    }
                    
                    [ray addObject:c_amount];
                    [ray addObject:c_spent];
                }
            }
            sqlite3_finalize(st);
        }
        
        for (int i = allBudget.count-1; i >= 0; i--)
        {
            NSMutableArray *a = [allBudget objectAtIndex:i];
            
            NSString *postData = [NSString stringWithFormat:@"entry.152079890=%@&entry.2099356811=%@&entry.1090870720=%@&entry.58372674=%@&entry.887497858=%@&entry.1309306391=%@&entry.763272716=%@&entry.1367868194=%@&entry.1886459060=%@&entry.169362762=%@&entry.1285347822=%@&entry.685118874=%@&entry.717710273=%@&entry.1955738301=%@&entry.26182424=%@&entry.426598365=%@&entry.1028591383=%@", userId, [a objectAtIndex:1], [a objectAtIndex:2], [a objectAtIndex:3], [a objectAtIndex:4], [a objectAtIndex:5], [a objectAtIndex:6], [a objectAtIndex:7], [a objectAtIndex:8], [a objectAtIndex:9], [a objectAtIndex:10], [a objectAtIndex:11], [a objectAtIndex:12], [a objectAtIndex:13], [a objectAtIndex:14], [a objectAtIndex:15], [a objectAtIndex:16]];
            
            NSString *postUrl = @"https://docs.google.com/forms/d/1HYdL3f7O9mU0X1g1xbBG4wvPU2-oZRHTmhYK8404Hqg/formResponse";
            
            //[self PostToGoogleDocs:postData :postUrl];
            
            /*NSLog(@"count: %d", a.count);
            
            NSLog(@"id: %d, st_dt: %@, wincome: %.2f, b_amount: %.2f, expense: %@, amount1: %@, spent1: %@, amount2: %@, spent2: %@, amount3: %@, spent3: %@, amount4: %@, spent4: %@, amount5: %@, spent5: %@, amount6: %@, spent6: %@", [[a objectAtIndex:0] intValue], [a objectAtIndex:1], [[a objectAtIndex:2] doubleValue], [[a objectAtIndex:3] doubleValue], [a objectAtIndex:4], [a objectAtIndex:5], [a objectAtIndex:6], [a objectAtIndex:7], [a objectAtIndex:8], [a objectAtIndex:9], [a objectAtIndex:10], [a objectAtIndex:11], [a objectAtIndex:12], [a objectAtIndex:13], [a objectAtIndex:14], [a objectAtIndex:15], [a objectAtIndex:16]);*/
        }
    }

    return allBudget;
}


-(void)PostToGoogleDocs:(NSString *)data :(NSString *)postUrl
{
    //NSString *post = @"entry.1=Hannan&entry.2=Affan";
    // Bismillah Spreadsheet - Testing Purposes NSURL *url = [NSURL URLWithString:@"https://docs.google.com/forms/d/1Vg-q9TeKA03dP2atPg_tz9SAI5zRhqXvWtdDJDcyWF0/formResponse"];
    
    NSString *post = data;
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString:postUrl];
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
    
    NSString *ReturnHTML=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",ReturnHTML);
}


@end











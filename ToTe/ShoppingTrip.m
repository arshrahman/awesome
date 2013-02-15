//
//  ShoppingTrip.m
//  ToTe
//
//  Created by user on 13/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ShoppingTrip.h"
#import "Database.h"
#import "sqlite3.h"

@implementation ShoppingTrip
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    NSMutableArray *shoppingList;
}

//Get current shopping trip
-(NSMutableArray *) checkShoppingTrip
{
    shoppingList =[[NSMutableArray alloc]init];
    
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    //get current Date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *theDate = [dateFormat stringFromDate:date];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM SHOPPING_LIST WHERE SHOPPING_DATE = '%@'", theDate];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                ShoppingTrip *st = [[ShoppingTrip alloc]init];
                
                NSString *shoppingId = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *budgetId = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *shoppingName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *shoppingDate = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *shoppingBudget = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *Duration = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *shoppingTotal = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                double convertTotal = [shoppingTotal doubleValue];
                int convertShoppingId = [shoppingId integerValue];
                int convertBudgetId = [budgetId integerValue];
                double convertShoppingBudget = [shoppingBudget doubleValue];
                
                [st setShoppingID:convertShoppingId];
                [st setBudgetID:convertBudgetId];
                [st setShoppingDate:shoppingDate];
                [st setShoppingTotal:convertTotal];
                [st setShoppingTripName:shoppingName];
                [st setShoppingBudget:convertShoppingBudget];
                [st setDuration:Duration];
                
                //Array
                [shoppingList addObject:st];
                
                NSLog(@"Show Today Purchase");
                
                //sqlite3_close(budgetDB);
            }
            
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Error!");
        }
    }
    sqlite3_close(budgetDB);
    return shoppingList;
}

- (void)addshoppingTrip:(NSString *)shoppingName :(double)shoppingBudget :(NSString *)Duration :(double)shoppingTotal
{
    char *error;
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    int maxID = 0;
    
    //get current Date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *theDate = [dateFormat stringFromDate:date];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        
        sqlite3_stmt *st;
        const char *queryMaxId = "SELECT MAX(BUDGET_ID) FROM BUDGET";
        
        if (sqlite3_prepare(budgetDB, queryMaxId, -1, &st, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(st)==SQLITE_ROW)
            {
                maxID = sqlite3_column_int(st, 0);
            }
        }
        sqlite3_finalize(st);
        
        
        NSString *querySql = [NSString stringWithFormat:@"INSERT INTO SHOPPING_LIST(BUDGET_ID, SHOPPING_NAME, SHOPPING_DATE, SHOPPING_BUDGET, DURATION, SHOPPING_TOTAL) VALUES ('%d','%@', '%@','%2f', '%@', '%2f')",maxID, shoppingName, theDate, shoppingBudget, Duration, shoppingTotal];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Shopping Trip Added!");
        }
        else
        {
            NSLog(@"Shopping Trip not complete!");
        }
    }
    sqlite3_close(budgetDB);
}

@end

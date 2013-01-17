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

@implementation Budget
{
    sqlite3 *budgetDB;
    //NSString *dbPathString;
    NSMutableArray *categoryList;
}

/*- (BOOL)InsertBudget:(double)budgetAmount :(double)wkIncome
{
    char *error;
    bool result = false;
    Database *d = [[Database alloc]init];
    NSString *dbPathString = [d SetDBPath];
    
    //get current Date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *theDate = [dateFormat stringFromDate:date];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PURCHASE(PURCHASE_DATE, CATEGORY_ID, PURCHASE_ITEM_PRICE, PURCHASE_ITEM_NAME) VALUES ('%@','%@','%2f', '%@')",theDate, category, price, name];
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            result = true;
            

            
            NSLog(@"Purchase Item Added!");
        }
        sqlite3_close(budgetDB);
    }
    return true;
}*/

@end

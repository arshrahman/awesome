//
//  Database.m
//  ToTe
//
//  Created by Abdul Rahman on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "Database.h"
#import "sqlite3.h"
#import "Purchase.h"
#import "viewPurchasesViewController.h"

@implementation Database
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
}

- (NSString *)SetDBPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:@"budgetizer.db"];
}

- (void)CreateDB
{
    dbPathString = [self SetDBPath];
    char *error;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString])
    {
        const char *dbPath = [dbPathString UTF8String];
        //create script here
        if (sqlite3_open(dbPath, &budgetDB)==SQLITE_OK)
        {
            const char *sql_stmt = "CREATE TABLE BUDGET(BUDGET_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, START_DATE TEXT, END_DATE TEXT, BUDGET_AMOUNT NUMERIC, WINCOME NUMERIC); CREATE TABLE CATEGORY (CATEGORY_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, CATEGORY_NAME TEXT, CATEGORY_IMAGE TEXT); CREATE TABLE BUDGET_CATEGORY(BUDGET_CATEGORY_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, BUDGET_ID INTEGER NOT NULL REFERENCES BUDGET(BUDGET_ID), CATEGORY_ID INTEGER NOT NULL REFERENCES CATEGORY(CATEGORY_ID), CATEGORY_SPENT NUMERIC, CATEGORY_AMOUNT NUMERIC); CREATE TABLE GOAL(GOAL_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, TITLE TEXT, DESCRIPTION TEXT, GOAL_AMOUNT NUMERIC, DEADLINE TEXT, GOAL_PHOTO TEXT, PRIORITY INTEGER, WEEKS_MET INTEGER); CREATE TABLE PURCHASE(PURCHASE_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, PURCHASE_DATE TEXT, CATEGORY_ID INTEGER NOT NULL REFERENCES CATEGORY(CATEGORY_ID), BUDGET_ID INTEGER NOT NULL REFERENCES BUDGET(BUDGET_ID), PURCHASE_ITEM_PRICE NUMERIC, PURCHASE_ITEM_NAME TEXT); CREATE TABLE SHOPPING_LIST(SHOPPING_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, BUDGET_ID INTEGER NOT NULL REFERENCES BUDGET(BUDGET_ID), SHOPPING_NAME TEXT, SHOPPING_DATE TEXT, SHOPPING_BUDGET NUMERIC, DURATION TEXT, SHOPPING_TOTAL NUMERIC); CREATE TABLE SHOPPING_ITEM(ITEM_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, SHOPPING_ID INTEGER NOT NULL REFERENCES SHOPPING_LIST(SHOPPING_ID), CATEGORY_ID INTEGER NOT NULL REFERENCES CATEGORY(CATEGORY_ID), SHOPPING_ITEM_NAME TEXT, SHOPPING_ITEM_PRICE NUMERIC, NECESSITY INTEGER, ITEMS_BOUGHT INTEGER); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Clothes', 'glyphicons_022_fire.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Books', 'glyphicons_014_train.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Saloon', 'glyphicons_028_cars.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Snacks', 'glyphicons_009_magic.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Charity', 'glyphicons_031_bus.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Parents', 'glyphicons_004_girl.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('School', 'glyphicons_000_glass.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Others', 'glyphicons_038_airplane.png');";
            
            @try
            {
                sqlite3_exec(budgetDB, sql_stmt, NULL, NULL, &error);
                FirstUse = 1;
            }
            @catch (NSException *exception)
            {
                FirstUse = 2;
                NSLog(@"Error: %s", error);
                NSLog(@"Exception %@", exception);
            }
            @finally
            {
                sqlite3_close(budgetDB);
            }
        }
    }
    else
    {
        if (self.checkBudgetExists)
        {
            FirstUse = 3;
        }
        else
        {
            FirstUse = 4;
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:FirstUse] forKey:@"FirstTimeUser"];
}

- (BOOL) checkBudgetExists
{
    bool result = false;
    int count;
    dbPathString = [self SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM BUDGET"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                count = sqlite3_column_int(statement, 0);
                NSLog(@"count : %d", count);
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
        
        if (count > 0)
        {
            result = true;
        }
        else
        {
            result = false;
        }
    }
    return result;
}

- (BOOL)InsertWeeklyIncome:(int)income
{
    char *error;
    bool result = false;
    dbPathString = [self SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO USER(INCOME) VALUES ('%d')",income];
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            result = true;
            NSLog(@"Income inserted!");
        }
        sqlite3_close(budgetDB);
    }
    return true;
}

@end


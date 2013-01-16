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
    //NSString *dbPathString;
}

- (NSString *)SetDBPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:@"budgetizer.db"];
}

- (void)CreateDB
{
    NSString *dbPathString = [self SetDBPath];
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString])
    {
        const char *dbPath = [dbPathString UTF8String];
        //create script here
        if (sqlite3_open(dbPath, &budgetDB)==SQLITE_OK)
        {
            //const char *sql_stmt = "CREATE TABLE Budget (budget_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,start_date NUMERIC UNIQUE,end_date NUMERIC UNIQUE,budget_amount NUMERIC,total_savings NUMERIC,income NUMERIC,PRIMARY KEY (budget_id)); CREATE TABLE Budget_Category (budget_id INTEGER NOT NULL,category_id INTEGER NOT NULL UNIQUE,category_name TEXT,category_spent NUMERIC,category_amount NUMERIC, PRIMARY KEY (budget_id,category_id)); CREATE TABLE Goal (goal_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE, title TEXT,description TEXT,goal_amount NUMERIC,deadline NUMERIC,goal_photo TEXT,priority INTEGER,weeks_met INTEGER,PRIMARY KEY (goal_id)); CREATE TABLE Purchase (purchase_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,purchase_date NUMERIC,item_category TEXT,item_price NUMERIC,item_name TEXT,PRIMARY KEY (purchase_id));CREATE TABLE Shopping_List (shopping_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,shopping_name TEXT,shopping_date NUMERIC,shopping_budget NUMERIC,duration NUMERIC,shopping_total NUMERIC,PRIMARY KEY (shopping_id));CREATE TABLE User (user_id NUMERIC NOT NULL UNIQUE,facebook TEXT,twitter TEXT,agreement_allow NUMERIC,facebook_allow NUMERIC,twitter_allow NUMERIC,PRIMARY KEY (user_id));CREATE TABLE Shopping_Item(shopping_id INTEGER NOT NULL,item_id INTEGER NOT NULL UNIQUE,item_category TEXT,item_price NUMERIC,item_name TEXT,necessity INTEGER,item_bought NUMERIC,PRIMARY KEY (shopping_id,item_id));ALTER TABLE Budget_Category ADD FOREIGN KEY (budget_id) REFERENCES Budget (budget_id); ALTER TABLE Shopping_Item ADD FOREIGN KEY (shopping_id) REFERENCES Shopping_List (shopping_id);";
            
            const char *sql_stmt = "CREATE TABLE BUDGET(BUDGET_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, START_DATE TEXT, END_DATE TEXT, BUDGET_AMOUNT NUMERIC, TOTAL_SAVINGS NUMERIC, WINCOME NUMERIC); CREATE TABLE CATEGORY (CATEGORY_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, CATEGORY_NAME TEXT, CATEGORY_IMAGE TEXT); CREATE TABLE BUDGET_CATEGORY(BUDGET_CATEGORY_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, BUDGET ID INTEGER NOT NULL REFERENCES BUDGET(BUDGET_ID), CATEGORY_ID INTEGER NOT NULL REFERENCES CATEGORY(CATEGORY_ID), CATEGORY_SPENT NUMERIC, CATEGORY_AMOUNT NUMERIC); CREATE TABLE GOAL(GOAL_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, TITLE TEXT, DESCRIPTION TEXT, GOAL_AMOUNT NUMERIC, DEADLINE TEXT, GOAL_PHOTO TEXT, PRIORITY INTEGER, WEEKS_MET INTEGER); CREATE TABLE PURCHASE(PURHCASE_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, PURCHASE_DATE TEXT, CATEGORY_ID INTEGER NOT NULL REFERENCES CATEGORY(CATEGORY_ID), PURCHASE_ITEM_PRICE NUMERIC, PURCHASE_ITEM_NAME TEXT); CREATE TABLE SHOPPING_LIST(SHOPPING_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, SHOPPING_NAME TEXT, SHOPPING_DATE TEXT, SHOPPING_BUDGET NUMERIC, DURATION TEXT, SHOPPING_TOTAL NUMERIC); CREATE TABLE SHOPPING_ITEM(ITEM_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, SHOPPING_ID INTEGER NOT NULL REFERENCES SHOPPING(SHOPPING_ID), CATEGORY_ID INTEGER NOT NULL REFERENCES CATEGORY(CATEGORY_ID), SHOPPING_ITEM_NAME TEXT, SHOPPING_ITEM_PRICE NUMERIC, NECESSITY INTEGER, ITEMS_BOUGHT INTEGER); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Clothes', 'glyphicons_022_fire.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Books', 'glyphicons_014_train.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Saloon', 'glyphicons_028_cars.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Snacks', 'glyphicons_009_magic.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Charity', 'glyphicons_031_bus.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('Parents', 'glyphicons_004_girl.png'); INSERT INTO CATEGORY(CATEGORY_NAME, CATEGORY_IMAGE) VALUES('School', 'glyphicons_000_glass.png');";
            
            sqlite3_exec(budgetDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(budgetDB);
        }
    }
}

- (BOOL) checkBudgetExists
{
    bool result = false;
    int count;
    NSString *dbPathString = [self SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM BUDGET"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                NSString *s = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                count = [s intValue];
                NSLog(@"count : %d", count);
            }
        }
        else
        {
            NSLog(@"Hi!");
        }
        
        if (count == 0)
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

- (BOOL) viewPurchases
{
    bool result = false;
    NSString *dbPathString = [self SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PURCHASE"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            
            if (sqlite3_step(statement)==SQLITE_ROW)
            {
                while (sqlite3_step(statement)==SQLITE_ROW)
                {
                    Purchase *p = [[Purchase alloc]init];
                    
                    NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                    NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *price = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    
                    double convertPrice = [price doubleValue];
                    
                    [p setName:name];
                    [p setCategory:category];
                    [p setDate:date];
                    [p setPrice:convertPrice];
                    
                    //Array
                    viewPurchasesViewController *vpvc = [[viewPurchasesViewController alloc]init];
                    [vpvc.purchasesList addObject:p];
                }
            }
            else
            {
                result = true;
            }
        }
        else
        {
            NSLog(@"Error!");
        }
    }
    return result;
}

- (BOOL)InsertWeeklyIncome:(int)income
{
    char *error;
    bool result = false;
    NSString *dbPathString = [self SetDBPath];
    
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

- (BOOL)addPurchase:(double)price :(NSString *)category : (NSString *)name
{
    char *error;
    bool result = false;
    NSString *dbPathString = [self SetDBPath];
    
    //get current Date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *theDate = [dateFormat stringFromDate:date];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PURCHASE(PURCHASE_DATE, CATEGORY_ID, PURCHASE_ITEM_PRICE, PURCHASE_ITEM_NAME) VALUES ('%@','%@','%.2f', '%@')",theDate, category, price, name];
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            result = true;
            
            Purchase *p = [[Purchase alloc] init];
            
            [p setName:name];
            [p setCategory:category];
            [p setPrice:price];
            [p setDate:theDate];
            
            viewPurchasesViewController *vpvc = [[viewPurchasesViewController alloc]init];
            [vpvc.purchasesList addObject:p];
            
            NSLog(@"Purchase Item Added!");
        }
        sqlite3_close(budgetDB);
    }
    return true;
}

@end




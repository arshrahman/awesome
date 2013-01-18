//
//  Purchase.m
//  ToTe
//
//  Created by user on 14/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "Purchase.h"
#import "Database.h"
#import "sqlite3.h"

@implementation Purchase
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    NSMutableArray *purchaseList;
}

- (void)addPurchase:(double)price :(NSString *)category : (NSString *)name
{
    char *error;
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    //get current Date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *theDate = [dateFormat stringFromDate:date];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *querySql = [NSString stringWithFormat:@"INSERT INTO PURCHASE(PURCHASE_DATE, CATEGORY_ID, PURCHASE_ITEM_PRICE, PURCHASE_ITEM_NAME) VALUES ('%@','%@','%2f', '%@')",theDate, category, price, name];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
        
            //if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
            //{
            
                Purchase *p = [[Purchase alloc] init];
            
                [p setName:name];
                [p setCategory:category];
                [p setPrice:price];
                [p setDate:theDate];
            
                [purchaseList addObject:p];
            
                NSLog(@"Purchase Item Added!");
            //}
            sqlite3_close(budgetDB);
        }
        else
        {
            NSLog(@"Insert not complete!");
        }
    }
}

- (NSMutableArray *) viewPurchases
{
    purchaseList =[[NSMutableArray alloc]init];
    
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PURCHASE"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                Purchase *p = [[Purchase alloc]init];
                
                NSString *uniqueId = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    
                NSString *date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                    
                NSString *price = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    
                double convertPrice = [price doubleValue];
                int convertId = [uniqueId integerValue];
                
                [p setUniqueId:convertId];
                [p setName:name];
                [p setCategory:category];
                [p setDate:date];
                [p setPrice:convertPrice];
                    
                //Array
                [purchaseList addObject:p];
            }
        }
        else
        {
            NSLog(@"Error!");
        }
    }
    return purchaseList;
}

- (void)deletePurchase:(int)uniqueId :(NSString *)name;
{
    
    char *error;
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *querySql = [NSString stringWithFormat:@"DELETE FROM PURCHASE WHERE PURCHASE_ITEM_NAME = '%@' AND PURCHASE_ID = '%d'", name, uniqueId];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            
            Purchase *p = [[Purchase alloc] init];
            
            [purchaseList removeObject:p];
            
            NSLog(@"Purchase Item Deleted!");
        }
        else
        {
            NSLog(@"Purchase Item Not Deleted!");
        }
        sqlite3_close(budgetDB);
    }

}

@end

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
#import "Budget.h"
#import "Category.h"
#import "CombinePurchases.h"


@implementation Purchase
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    NSMutableArray *purchaseList;
    NSMutableArray *categoryList;
}

//GetDate
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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *Mon = [dateFormat stringFromDate:monday];
    
    NSLog(@"Monday: %@", Mon);
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 6;
    dayComponent.hour = 23;
    dayComponent.minute = 59;
    dayComponent.second = 59;
    
    NSDate *sunday = [calendar dateByAddingComponents:dayComponent toDate:monday options:0];
    NSString *Sun = [dateFormat stringFromDate:sunday];
    
    NSLog(@"Sunday: %@", Sun);
    
    [dates addObject:[formatter stringFromDate:monday]];
    [dates addObject:[formatter stringFromDate:sunday]];
    
    return dates;
}

//Add
- (void)addPurchase:(double)price :(int)category : (NSString *)name :(int)priority
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

        
        NSString *querySql = [NSString stringWithFormat:@"INSERT INTO PURCHASE(PURCHASE_DATE, CATEGORY_ID, BUDGET_ID, PURCHASE_ITEM_PRICE, PURCHASE_ITEM_NAME, PURCHASE_ITEM_PRIORITY) VALUES ('%@','%d', '%d','%2f', '%@', '%d')",theDate, category, maxID, price, name, priority];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Purchase Item Added!");
        }
        else
        {
            NSLog(@"Insert not complete!");
        }
    }
    sqlite3_close(budgetDB);
}

//View Today Purchase
- (NSMutableArray *) viewTodayPurchases
{
    purchaseList =[[NSMutableArray alloc]init];
    
    Category *c = [[Category alloc]init];
    categoryList = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        [categoryList addObject:cc];
    }
    
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
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PURCHASE WHERE PURCHASE_DATE = '%@'", theDate];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                Purchase *p = [[Purchase alloc]init];
                
                NSString *uniqueId = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    
                NSString *date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                    
                NSString *price = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *priority = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                    
                double convertPrice = [price doubleValue];
                int convertId = [uniqueId integerValue];
                int convertPriority = [priority integerValue];
                int convertCate = [category integerValue];
                int checkCate = convertCate - 1;
                
                [p setUniqueId:convertId];
                [p setName:name];
                [p setDate:date];
                [p setPrice:convertPrice];
                [p setPriority:convertPriority];
                [p setCateID:convertCate];
                
                c = [categoryList objectAtIndex:checkCate];
                
                [p setCategory: c.category_name];
                    
                //Array
                [purchaseList addObject:p];
                
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
    return purchaseList;
}

//View This Week Purchase
- (NSMutableArray *) viewThisWeekPurchases
{
    purchaseList =[[NSMutableArray alloc]init];
    
    Category *c = [[Category alloc]init];
    categoryList = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        [categoryList addObject:cc];
    }
    
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PURCHASE WHERE BUDGET_ID = (SELECT MAX(BUDGET_ID) FROM BUDGET)"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                Purchase *p = [[Purchase alloc]init];
                
                NSString *uniqueId = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *price = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *priority = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                double convertPrice = [price doubleValue];
                int convertId = [uniqueId integerValue];
                int convertPriority = [priority integerValue];
                int convertCate = [category integerValue];
                int checkCate = convertCate - 1;
                
                [p setUniqueId:convertId];
                [p setName:name];
                [p setDate:date];
                [p setPrice:convertPrice];
                [p setPriority:convertPriority];
                [p setCateID:convertCate];
                
                c = [categoryList objectAtIndex:checkCate];
                
                [p setCategory: c.category_name];
                
                //Array
                [purchaseList addObject:p];
                
                NSLog(@"Show This Week Purchase");
                
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
    return purchaseList;
}

//Delete
- (void)deletePurchase:(int)uniqueId;
{
    char *error;
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *querySql = [NSString stringWithFormat:@"DELETE FROM PURCHASE WHERE PURCHASE_ID = '%d'", uniqueId];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            /*
            Purchase *p = [[Purchase alloc] init];
            
            [purchaseList removeObject:p];
            */
            NSLog(@"Purchase Item Deleted!");
        }
        else
        {
            NSLog(@"Purchase Item Not Deleted!");
        }
        sqlite3_close(budgetDB);
    }

}

//Update
-(void)updatePurchase:(int)uniqueId :(NSString *)name :(int)category :(double)price :(int)priority;
{
    char *error;
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *querySql = [NSString stringWithFormat:@"UPDATE PURCHASE SET PURCHASE_ITEM_NAME = '%@', CATEGORY_ID = '%d', PURCHASE_ITEM_PRICE ='%2f', PURCHASE_ITEM_PRIORITY = '%d' WHERE PURCHASE_ID = '%d'", name, category, price, priority, uniqueId];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Purchase Item Updated!");
        }
        else
        {
            NSLog(@"Purchase Item Not Updated!");
        }
        sqlite3_close(budgetDB);
    }
}

//Pol
//History Module
//View All Purchases
- (NSMutableArray *) viewAllPurchases
{
    purchaseList =[[NSMutableArray alloc]init];
    
    Category *c = [[Category alloc]init];
    categoryList = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        [categoryList addObject:cc];
    }
    
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PURCHASE"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            NSLog(@"Viewall if");
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                CombinePurchases *p = [[CombinePurchases alloc]init];
                
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *price = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *priority = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                double convertPrice = [price doubleValue];
                int convertPriority = [priority integerValue];
                int convertCate = [category integerValue];
                int checkCate = convertCate - 1;
                
                [p setName:name];
                [p setDate:date];
                [p setPrice:convertPrice];
                [p setPriority:convertPriority];
                [p setCateID:convertCate];
                
                c = [categoryList objectAtIndex:checkCate];
                
                [p setCategory: c.category_name];
                
                //Array
                [purchaseList addObject:p];
                
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
    NSLog(@"%d", purchaseList.count);
    return purchaseList;
}

@end

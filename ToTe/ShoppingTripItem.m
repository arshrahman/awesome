//
//  ShoppingTripItem.m
//  ToTe
//
//  Created by user on 13/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ShoppingTripItem.h"
#import "Database.h"
#import "sqlite3.h"
#import "Budget.h"
#import "Category.h"
#import "CombinePurchases.h"

@implementation ShoppingTripItem
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    NSMutableArray *shoppingItemList;
    NSMutableArray *categoryList;
}

//Get shopping Items
- (NSMutableArray *) viewCurrentShoppingTrip:(int)shoppingID
{
    shoppingItemList =[[NSMutableArray alloc]init];
    
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
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM SHOPPING_ITEM WHERE SHOPPING_ID = '%d'", shoppingID];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
                
                NSString *itemId = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *shoppingId = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *shoppingItemName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *shoppingItemPrice = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *necessity = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *check = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                NSLog(check);
                //NSString *itemBought = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                double convertPrice = [shoppingItemPrice doubleValue];
                int convertItemId = [itemId integerValue];
                int convertShoppingId = [shoppingId integerValue];
                int convertNecessity = [necessity integerValue];
                int convertCate = [category integerValue];
                //int convertItemBought = [itemBought integerValue];
                int checkCate = convertCate - 1;
                int convertCheck = [check integerValue];
                
                [sti setItemID:convertItemId];
                [sti setShoppingID:convertShoppingId];
                [sti setShoppingItemName:shoppingItemName];
                [sti setShoppingItemPrice:convertPrice];
                [sti setNecessity:convertNecessity];
                [sti setCategoryID:convertCate];
                [sti setCheck:convertCheck];
                //[sti setItemsBought:convertItemBought];
                
                c = [categoryList objectAtIndex:checkCate];
                
                [sti setCategory: c.category_name];
                
                //Array
                [shoppingItemList addObject:sti];
                
                NSLog(@"Show Shopping Item");
                
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
    return shoppingItemList;
}

- (void)deleteShoppingItem:(int)itemID
{
    char *error;
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *querySql = [NSString stringWithFormat:@"DELETE FROM SHOPPING_ITEM WHERE ITEM_ID = '%d'", itemID];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Shopping Item Deleted!");
        }
        else
        {
            NSLog(@"Shopping Item Not Deleted!");
        }
        sqlite3_close(budgetDB);
    }
}

- (void)addshoppingItem:(NSString *)shoppingItemName :(double)shoppingItemPrice :(int)categoryID :(int)necessity: (int)check
{
    char *error;
    Database *db = [[Database alloc]init];
    dbPathString = [db SetDBPath];
    
    int maxID = 0;
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *st;
        const char *queryMaxId = "SELECT MAX(SHOPPING_ID) FROM SHOPPING_LIST";
        
        if (sqlite3_prepare(budgetDB, queryMaxId, -1, &st, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(st)==SQLITE_ROW)
            {
                maxID = sqlite3_column_int(st, 0);
            }
        }
        sqlite3_finalize(st);
        
        NSString *querySql = [NSString stringWithFormat:@"INSERT INTO SHOPPING_ITEM(SHOPPING_ID, CATEGORY_ID, SHOPPING_ITEM_NAME, SHOPPING_ITEM_PRICE, NECESSITY, SHOPPING_CHECK) VALUES ('%d','%d', '%@','%2f', '%d', '%d')",maxID, categoryID, shoppingItemName, shoppingItemPrice, necessity, check];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Shopping Item Added!");
        }
        else
        {
            NSLog(@"Shopping Item not complete!");
        }
    }
    sqlite3_close(budgetDB);
}

-(void)updateShoppingItem:(int)ItemID :(NSString *)shoppingItemName :(int)categoryID :(double)shoppingItemPrice: (int)necessity: (int)check
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
        NSString *querySql = [NSString stringWithFormat:@"UPDATE SHOPPING_ITEM SET CATEGORY_ID = '%d', SHOPPING_ITEM_NAME = '%@', SHOPPING_ITEM_PRICE ='%2f', NECESSITY = '%d', SHOPPING_CHECK = '%d', SHOPPING_ITEM_DATE = '%@' WHERE ITEM_ID = '%d'", categoryID, shoppingItemName, shoppingItemPrice, necessity, check, theDate, ItemID];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_exec(budgetDB, query_sql, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Shopping Item Updated!");
        }
        else
        {
            NSLog(@"Shopping Item Not Updated!");
        }
        sqlite3_close(budgetDB);
    }
}

//For History module, gets everything
//only for displaying purposes for history module and cannot be use in any other module.
- (NSMutableArray *) getShoppingTrip
{
    shoppingItemList =[[NSMutableArray alloc]init];
    
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
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM SHOPPING_ITEM WHERE SHOPPING_CHECK = 1"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                CombinePurchases *sti = [[CombinePurchases alloc]init];
                
                NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *shoppingItemName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *shoppingItemPrice = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *necessity = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *shopping_date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                
                double convertPrice = [shoppingItemPrice doubleValue];
                int convertNecessity = [necessity integerValue];
                int convertCate = [category integerValue];
                int checkCate = convertCate - 1;
                
                [sti setName:shoppingItemName];
                [sti setPrice:convertPrice];
                [sti setPriority:convertNecessity];
                [sti setCateID:convertCate];
                [sti setDate:shopping_date];
                
                c = [categoryList objectAtIndex:checkCate];
                
                [sti setCategory: c.category_name];
                
                //Array
                [shoppingItemList addObject:sti];
                
                NSLog(@"Show Shopping Item");
                
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
    return shoppingItemList;
}

- (NSMutableArray *) getShoppingTripItem:(int)ID
{
    shoppingItemList =[[NSMutableArray alloc]init];
    
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
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM SHOPPING_ITEM WHERE SHOPPING_CHECK = 1 AND SHOPPING_ID == '%d'", ID];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
                
                NSString *category = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *shoppingItemName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *shoppingItemPrice = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *necessity = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *shopping_date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                
                double convertPrice = [shoppingItemPrice doubleValue];
                int convertNecessity = [necessity integerValue];
                int convertCate = [category integerValue];
                int checkCate = convertCate - 1;
                
                [sti setShoppingItemName:shoppingItemName];
                [sti setShoppingItemPrice:convertPrice];
                [sti setNecessity:convertNecessity];
                [sti setCategoryID:convertCate];
                [sti setDate:shopping_date];
                
                c = [categoryList objectAtIndex:checkCate];
                
                [sti setCategory: c.category_name];
                
                //Array
                [shoppingItemList addObject:sti];
                
                NSLog(@"Show Shopping Item");
                
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
    return shoppingItemList;
}


@end

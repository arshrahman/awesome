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
                
                NSString *itemBought = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                double convertPrice = [shoppingItemPrice doubleValue];
                int convertItemId = [itemId integerValue];
                int convertShoppingId = [shoppingId integerValue];
                int convertNecessity = [necessity integerValue];
                int convertCate = [category integerValue];
                int convertItemBought = [itemBought integerValue];
                int checkCate = convertCate - 1;
                
                [sti setItemID:convertItemId];
                [sti setShoppingID:convertShoppingId];
                [sti setShoppingItemName:shoppingItemName];
                [sti setShoppingItemPrice:convertPrice];
                [sti setNecessity:convertNecessity];
                [sti setCategoryID:convertCate];
                [sti setItemsBought:convertItemBought];
                
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

- (void)deleteShoppingItem:(int)shoppingID :(int)itemID
{
    
}

- (void)addshoppingItem:(NSString *)shoppingItemName :(double)shoppingItemPrice :(int)categoryID :(int)necessity
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
        
        NSString *querySql = [NSString stringWithFormat:@"INSERT INTO SHOPPING_ITEM(SHOPPING_ID, CATEGORY_ID, SHOPPING_ITEM_NAME, SHOPPING_ITEM_PRICE, NECESSITY) VALUES ('%d','%d', '%@','%2f', '%d')",maxID, categoryID, shoppingItemName, shoppingItemPrice, necessity];
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

-(void)updateShoppingItem:(int)uniqueId :(NSString *)shoppingItemName :(int)categoryID :(double)ShoppngItemPrice: (int)necessity :(int)itemBought
{
    
}

@end

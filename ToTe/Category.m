//
//  Category.m
//  ToTe
//
//  Created by Abdul Rahman on 16/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "Category.h"
#import "Database.h"
#import "sqlite3.h"

@implementation Category
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    NSMutableArray *categoryList;
}

-(NSMutableArray *)SelectAllCategory
{
    categoryList = [[NSMutableArray alloc]init];
    
    Database *d = [[Database alloc]init];    
    dbPathString = [d SetDBPath];
    
    NSLog(@"Hello");
    
    if (sqlite3_open([ dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CATEGORY"];
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                Category *c = [[Category alloc]init];
                    
                NSString *cid = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    
                [c setCategory_id:[cid intValue]];
                    
                [c setCategory_name:[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                    
                [c setCategory_image:[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
                
                [categoryList addObject:c];
            }
        }
        else
        {
            NSLog(@"Error!");
        }
    }
    return categoryList;
}

@end

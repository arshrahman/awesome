//
//  BudgetCategory.m
//  ToTe
//
//  Created by Abdul Rahman on 17/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "BudgetCategory.h"
#import "Database.h"
#import "sqlite3.h"

@implementation BudgetCategory
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
    NSMutableArray *categoryList;
}



@end

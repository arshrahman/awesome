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

-(NSMutableArray*)GetDate
{
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:today];
    
    [nowComponents setWeekday:2];
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    NSDate *monday = [calendar dateFromComponents:nowComponents];
    NSLog(@"Monday: %@", monday);
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 6;
    dayComponent.hour = 23;
    dayComponent.minute = 59;
    dayComponent.second = 40;
    
    NSDate *sunday = [calendar dateByAddingComponents:dayComponent toDate:monday options:0];
    NSLog(@"Sunday: %@", sunday);

    [dates addObject:monday];
    [dates addObject:sunday];
        
    return dates;
}



- (BOOL)InsertBudget:(double)budgetAmount :(double)wkIncome
{
    char *error;
    bool result = false;
    Database *d = [[Database alloc]init];
    NSString *dbPathString = [d SetDBPath];
    
    NSMutableArray *dates = [self GetDate];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO BUDGET(START_DATE, END_DATE, BUDGET_AMOUNT, WINCOME) VALUES ('%@','%@','%2f', '%f')",[dates objectAtIndex:0], [dates objectAtIndex:1], budgetAmount, wkIncome];
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            result = true;
            NSLog(@"Budget Added!");
        }
        sqlite3_close(budgetDB);
    }
    return result;
}

@end

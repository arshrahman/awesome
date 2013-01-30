//
//  Goal.m
//  ToTe
//
//  Created by Abdul Rahman on 29/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "Goal.h"
#import "Database.h"
#import "sqlite3.h"

@implementation Goal
{
    sqlite3 *budgetDB;
    NSString *dbPathString;
}

-(void)InsertGoal:(NSString *)g_title:(NSString *)g_description:(int)g_amount:(NSString *)deadline:(NSString *)g_photo:(int)amount_tosave:(NSString *)g_start_date
{
    char *error;

    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }

    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@""];
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {

        }
        sqlite3_close(budgetDB);
    }

}

-(NSString *)getCurrentDay
{
    NSDate *today = [[NSDate alloc]init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    return [format stringFromDate:today];
}


-(NSString *)ConvertDateFormat:(NSString *)end_date
{
    NSLog(@"selected date: %@", end_date);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    NSDate *newDate = [dateFormat dateFromString:end_date];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat stringFromDate:newDate];
}

-(NSInteger)WeeksBetweenDate:(NSString *)end_date
{
    int weeks = 1;
    int weekday;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * lastDay= [[NSDate alloc]init];
    lastDay = [formatter dateFromString:[self ConvertDateFormat:end_date]];
    NSDate *today  = [formatter dateFromString:[self getCurrentDay]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:today];
    weekday = 8 - [comps weekday];
    
    NSTimeInterval distanceBetweenDates = [lastDay timeIntervalSinceDate:today];
    NSInteger days = (distanceBetweenDates / (60*1440))-weekday;
    
    weeks += days/7;
        
    if (ceil(days%7) > 0)
    {
        weeks += 1;
    }

    return weeks;
}

@end

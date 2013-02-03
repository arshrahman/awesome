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

-(int)InsertGoal:(NSString *)g_title:(NSString *)g_description:(int)g_amount:(NSString *)deadline:(NSString *)g_photo:(int)amount_tosave
{
    char *error;
    int rowId = 1;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {            
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO GOAL (TITLE, DESCRIPTION, GOAL_AMOUNT, DEADLINE, GOAL_PHOTO, AMOUNT_TOSAVE, GOAL_START_DATE, PRIORITY) SELECT '%@', '%@', %d, '%@', '%@', %d, '%@', COALESCE(MAX(PRIORITY), 0) + 1 FROM GOAL;", g_title, g_description, g_amount, deadline, g_photo, amount_tosave, [self getCurrentDay]];
            
        const char *insert_stmt = [insertStmt UTF8String];
            
        if (sqlite3_exec(budgetDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            rowId = sqlite3_last_insert_rowid(budgetDB);
        }
        else
        {
            NSLog(@"Insert Goal Error: %s", error);
        }
    }
    else
    {
        NSLog(@"Insert Goal: cannot open db!");
    }
    sqlite3_close(budgetDB);
    
    return rowId;
}

-(NSMutableArray *)SelectAllGoals
{
    NSMutableArray *goals = [[NSMutableArray alloc]init];
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT GOAL_ID, TITLE, GOAL_AMOUNT, GOAL_PHOTO, WEEKS_MET, AMOUNT_TOSAVE FROM GOAL ORDER BY PRIORITY"];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                Goal *gg = [[Goal alloc]init];
                
                gg.goal_id = sqlite3_column_int(statement, 0);
                gg.goal_title = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                gg.goal_amount = sqlite3_column_int(statement, 2);
                gg.goal_photo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                gg.weeks_met = sqlite3_column_int(statement, 4);
                gg.amount_tosave = sqlite3_column_int(statement, 5);
                
                [goals addObject:gg];
            }
        }
        else
        {
            NSLog(@"Got Error in select all goals");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(budgetDB);
    
    return goals;
}

-(NSMutableArray *)SelectGoal:(int)g_id
{
    NSMutableArray *goal = [[NSMutableArray alloc]init];
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *querySql = [NSString stringWithFormat:@"SELECT GOAL_ID, TITLE, DESCRIPTION, GOAL_AMOUNT, DEADLINE, GOAL_PHOTO, WEEKS_MET, AMOUNT_TOSAVE, GOAL_START_DATE FROM GOAL WHERE GOAL_ID = %d", g_id];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(budgetDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                Goal *gg = [[Goal alloc]init];
                
                gg.goal_id = sqlite3_column_int(statement, 0);
                gg.goal_title = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                gg.goal_description = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                gg.goal_amount = sqlite3_column_int(statement, 3);
                gg.deadline = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                gg.goal_photo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                gg.weeks_met = sqlite3_column_int(statement, 6);
                gg.amount_tosave = sqlite3_column_int(statement, 7);
                gg.goal_start_date = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                
                [goal addObject:gg];
            }
        }
        else
        {
            NSLog(@"Got Error in select goal");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(budgetDB);
    
    return goal;
}

-(BOOL)UpdateGoal:(NSString *)g_title:(NSString *)g_description:(int)g_amount:(NSString *)deadline:(NSString *)g_photo:(int)amount_tosave:(int)g_id
{
    char *error;
    BOOL success = FALSE;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {            
        NSString *updateStmt = [NSString stringWithFormat:@"UPDATE GOAL SET TITLE = '%@', DESCRIPTION = '%@', GOAL_AMOUNT = %d, DEADLINE = '%@', GOAL_PHOTO = '%@',  AMOUNT_TOSAVE = %d WHERE GOAL_ID = %d", g_title, g_description, g_amount, deadline, g_photo, amount_tosave, g_id];
            
        const char *update_stmt = [updateStmt UTF8String];
            
        if (sqlite3_exec(budgetDB, update_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            //NSLog(@"Successfully Goal Updated!");
            success = TRUE;
        }
        else
        {
            NSLog(@"Error: %s", error);
        }
    }
    else
    {
        NSLog(@"Goal: cannot open db!");
    }
    sqlite3_close(budgetDB);
    
    return success;
}
    
-(BOOL)DeleteGoal:(int)g_id
{
    char *error;
    BOOL success = FALSE;
    
    if(dbPathString == NULL)
    {
        Database *d = [[Database alloc]init];
        dbPathString = d.SetDBPath;
    }
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        NSString *deleteStmt = [NSString stringWithFormat:@"DELETE FROM GOAL WHERE GOAL_ID = %d", g_id];
        
        const char *delete_stmt = [deleteStmt UTF8String];
        
        if (sqlite3_exec(budgetDB, delete_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            //NSLog(@"Goal Deleted!");
            success = TRUE;
        }
        else
        {
            NSLog(@"Delete Goal: cannot open db!");
        }
        sqlite3_close(budgetDB);
    }
    return success;
}


-(void)ReorderPriority:(NSMutableArray *)gIdArray
{
    char *error;
    NSString *update_stmt = @"";
    
    for (int i = 0; i < gIdArray.count; i++)
    {
        NSString *temp = [NSString stringWithFormat:@"UPDATE GOAL SET PRIORITY = %d WHERE GOAL_ID = %d; ", i+1, [[gIdArray objectAtIndex:i] intValue]];
        update_stmt = [update_stmt stringByAppendingString:temp];
    }
    
    const char *updatestmt = [update_stmt UTF8String];
    
    if (sqlite3_open([dbPathString UTF8String], &budgetDB)==SQLITE_OK)
    {
        @try
        {
            sqlite3_exec(budgetDB, updatestmt, NULL, NULL, &error);
        }
        @catch (NSException *exception)
        {
            NSLog(@"Error: %s", error);
            NSLog(@"Exception %@", exception);
        }
        @finally
        {
            sqlite3_close(budgetDB);
        }
    }
}


-(NSString *)getCurrentDay
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setLocale:[NSLocale currentLocale]];
    [format setDateFormat:@"yyyy-MM-dd"];
        
    return [format stringFromDate:today];
}

-(NSString *)ConvertDateFormat:(NSString *)end_date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *newDate = [dateFormat dateFromString:end_date];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormat stringFromDate:newDate];
}


-(NSInteger)WeeksBetweenDate:(NSDate *)end_date
{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *today  = [formatter dateFromString:[self getCurrentDay]];
    
    int weeks = 0;
    int Startweekday;
    int EndWeekDay;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:today];
    
    if (comps.weekday == 1)
    {
        Startweekday = 1;
    }
    else if (comps.weekday == 2)
    {
        Startweekday = 0;
    }
    else
    {
        Startweekday = 7 - ([comps weekday] - 2);
    }
    
    NSDateComponents *comps1 = [calendar components:NSWeekdayCalendarUnit fromDate:end_date];
    EndWeekDay = [comps1 weekday] - 1;
    
    NSTimeInterval distanceBetweenDates = [end_date timeIntervalSinceDate:today];
    NSInteger days = (distanceBetweenDates / (60*1440)) - (Startweekday + EndWeekDay);
    
    if (Startweekday > 0) weeks += 1;
    if (EndWeekDay > 0) weeks += 1;
    
    
    weeks += days/7;
    
    if (ceil(days%7) > 0)
    {
        weeks += 1;
    }
    
    //NSLog(@"StartWeekday: %d, EndWeekday: %d, Days: %d, Weeks: %d", Startweekday, EndWeekDay, days, weeks);
    
    return weeks;
}

-(NSString *)DateToString:(NSDate *)dt
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setLocale:[NSLocale currentLocale]];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    return [format stringFromDate:dt];
}

-(NSDate *)StringToDate:(NSString *)strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter dateFromString:strDate];
}

-(NSInteger)WeeksBetweenTwoDate:(NSDate *)start_date:(NSDate *)end_date
{
    int weeks = 0;
    int Startweekday;
    int EndWeekDay;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:start_date];
    
    if (comps.weekday == 1)
    {
        Startweekday = 1;
    }
    else if (comps.weekday == 2)
    {
        Startweekday = 0;
    }
    else
    {
        Startweekday = 7 - ([comps weekday] - 2);
    }
    
    NSDateComponents *comps1 = [calendar components:NSWeekdayCalendarUnit fromDate:end_date];
    EndWeekDay = [comps1 weekday] - 1;
    
    NSTimeInterval distanceBetweenDates = [end_date timeIntervalSinceDate:start_date];
    NSInteger days = (distanceBetweenDates / (60*1440)) - (Startweekday + EndWeekDay);
    
    if (Startweekday > 0) weeks += 1;
    if (EndWeekDay > 0) weeks += 1;
    
    
    weeks += days/7;
    
    if (ceil(days%7) > 0)
    {
        weeks += 1;
    }
    
    //NSLog(@"StartWeekday: %d, EndWeekday: %d, Days: %d, Weeks: %d", Startweekday, EndWeekDay, days, weeks);
    
    return weeks;

}

@end

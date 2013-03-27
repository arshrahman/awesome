//
//  CPDStockPriceStore.m
//  CorePlotDemo
//
//  NB: Price data obtained from Yahoo! Finance:
//  http://finance.yahoo.com/q/hp?s=AAPL
//  http://finance.yahoo.com/q/hp?s=GOOG
//  http://finance.yahoo.com/q/hp?s=MSFT
//
//  Created by Steve Baranski on 5/4/12.
//  Copyright (c) 2012 komorka technology, llc. All rights reserved.
//

#import "CPDStockPriceStore.h"
#import "CPDConstants.h"
#import "ExpenditureTrendViewController.h"
#import "Budget.h"
#import "BudgetCategory.h"
#import "ByCategoryDateViewController.h"

@interface CPDStockPriceStore ()
{
    NSMutableArray *numWeeks;
}


@end

@implementation CPDStockPriceStore

#pragma mark - Class methods

+ (CPDStockPriceStore *)sharedInstance
{
    static CPDStockPriceStore *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];      
    });
    
    return sharedInstance;
}

#pragma mark - API methods

- (NSArray *)tickerSymbols
{
    static NSArray *symbols = nil;
    if (!symbols)
    {
        symbols = [NSArray arrayWithObjects:
                   @"Category Expend",
                   @"Expend",
                   @"Saving",
                   nil];
    }
    return symbols;
}

//!-- Everything above this codes below needs to be removed --! 

//The Real Data Graph Codes

//Scatter Graph!
//Max 8 week
//Min 1 week

//Weeks - This is going to be use for all the ploting of graph
//calculate the 8 week before hand during the Expediture/By category selection stage.
//Then compute it here.
- (NSArray *)EightWeek:(int)containerID
{
    NSArray *week = nil;
    NSMutableArray *convertWeek = [[NSMutableArray alloc]init];
    if (!week)
    {
        ExpenditureTrendViewController *ETVC = [[ExpenditureTrendViewController alloc]init];
        
        //First level
        NSMutableArray *expendContainer = [ETVC getExpendAndSaving];
        //Second Level
        NSMutableArray *currentExpend = [expendContainer objectAtIndex:containerID];
        //Inside of second level which contains the 8 weeks expends
        for(Budget *b in currentExpend)
        {
            NSString *start = b.startDate;
            NSString *end = b.endDate;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *start1 = [formatter dateFromString:start];
            NSDate *end1 = [formatter dateFromString:end];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd MMM"];
            
            start = [dateFormat stringFromDate:start1];
            end = [dateFormat stringFromDate:end1];
            
            NSString *date = [NSString stringWithFormat:@"%@ - %@", start, end];
            [convertWeek addObject:date];
            week = convertWeek;
            numWeeks = convertWeek;
            NSLog(@"%d number of week", week.count);
        }
        
        NSLog(@"%@", week);
    }
    return week;
}

//Data
//Get the data from the previous view controller when gets the amount of weeks and pass it to this class to get the value in order to plot the graph.
//Scatter Graph

//Expend Check - container ID to get the different week
- (NSArray *)weeklyExpend:(NSString *)tickerSymbol:(int)containerID
{
    NSArray *expend = nil;
    NSMutableArray *convertExpend = [[NSMutableArray alloc]init];
    if (!expend)
    {
        ExpenditureTrendViewController *ETVC = [[ExpenditureTrendViewController alloc]init];
        
        //First level
        NSMutableArray *expendContainer = [ETVC getExpendAndSaving];
        //Second Level
        NSMutableArray *currentExpend = [expendContainer objectAtIndex:containerID];
        //Inside of second level which contains the 8 weeks expends
        for(Budget *b in currentExpend)
        {
            NSLog(@"%d", b.budget_id);
            [convertExpend addObject:[NSDecimalNumber numberWithDouble:[b GetExpenses:b.budget_id]]];
            expend = convertExpend;
        }
        NSLog(@"%@", expend);
    }
    return expend;
}

//Saving Check
- (NSArray *)weeklySaving:(NSString *)tickerSymbol:(int)containerID
{
    static NSArray *saving = nil;
    NSMutableArray *convertSaving = [[NSMutableArray alloc]init];
    if (!saving)
    {
        ExpenditureTrendViewController *ETVC = [[ExpenditureTrendViewController alloc]init];
        
        //First level
        NSMutableArray *savingContainer = [ETVC getExpendAndSaving];
        //Second Level
        NSMutableArray *currentSaving = [savingContainer objectAtIndex:containerID];
        //Inside of second level which contains the 8 weeks expends
        NSLog(@"%d saving Count", currentSaving.count);
        for(Budget *b in currentSaving)
        {
            NSLog(@"%d", b.budget_id);
            
            double expend = [b GetExpenses:b.budget_id];
            
            if(expend > b.wincome)
            {
                [convertSaving addObject:[NSDecimalNumber numberWithDouble:0.0]];
            }
            else if(expend < b.wincome)
            {
                [convertSaving addObject:[NSDecimalNumber numberWithDouble:(b.wincome - expend)]];
            }
            else
            {
                [convertSaving addObject:[NSDecimalNumber numberWithDouble:0.0]];
            }
            
            saving = convertSaving;
        }
        NSLog(@"%@", saving);
    }
    return saving;
}

//Bar Graph
- (NSArray *)weeklyExpendByCategory:(NSString *)tickerSymbol:(int)containerID:(int)catID
{
    NSArray *categoryExpend = nil;
    NSMutableArray *convertCategoryExpend = [[NSMutableArray alloc]init];
    
    if (!categoryExpend)
    {
        ByCategoryDateViewController *BCDVC = [[ByCategoryDateViewController alloc]init];
        
        //First level
        NSMutableArray *categoryExpendContainer = [BCDVC getEightWeekBudget];
        //Second Level
        NSMutableArray *currentCategoryExpend = [categoryExpendContainer objectAtIndex:containerID];
        //Inside of second level which contains the 8 weeks expends
        for(Budget *b in currentCategoryExpend)
        {
            NSLog(@"%d", b.budget_id);
            //Get Budget Category
            NSMutableArray *BClist = [b GetBudgetCategories:b.budget_id];
            
            for(BudgetCategory *bc in BClist)
            {
                NSLog(@"%d BCLIST", BClist.count);
                if(bc.category_id == catID)
                {
                    NSLog(@"%d", catID);
                    NSLog(@"%d", bc.category_id);
                    NSLog(bc.bcategory_name);
                    NSLog(@"%f", bc.category_spent);
                    if(bc.category_spent != 0)
                    {
                        [convertCategoryExpend addObject:[NSDecimalNumber numberWithDouble:bc.category_spent]];
                    }
                    //break;
                }
            }
            
            if(convertCategoryExpend.count == 0 || convertCategoryExpend.count < numWeeks.count)
            {
                 [convertCategoryExpend addObject:[NSDecimalNumber numberWithDouble:0.0]];
            }
            
            categoryExpend = convertCategoryExpend;
            NSLog(@"%d weeks count:", numWeeks.count);
            NSLog(@"%d category count:", categoryExpend.count);
        }
        NSLog(@"%@", categoryExpend);
    }
    return categoryExpend;
}


@end

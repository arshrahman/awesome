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
    ExpenditureTrendViewController *ETVC = [[ExpenditureTrendViewController alloc]init];
    
    //First level
    NSMutableArray *expendContainer = [ETVC getExpendAndSaving];
    
    if (!week)
    {
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
        }
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
    ExpenditureTrendViewController *ETVC = [[ExpenditureTrendViewController alloc]init];
    
    //First level
    NSMutableArray *expendContainer = [ETVC getExpendAndSaving];
    
    if (!expend)
    {
        //Second Level
        NSMutableArray *currentExpend = [expendContainer objectAtIndex:containerID];
        //Inside of second level which contains the 8 weeks expends
        for(Budget *b in currentExpend)
        {
            [convertExpend addObject:[NSDecimalNumber numberWithDouble:[b GetExpenses:b.budget_id]]];
            expend = convertExpend;
        }
    }
    return expend;
}

//Saving Check
- (NSArray *)weeklySaving:(NSString *)tickerSymbol:(int)containerID
{
    static NSArray *saving = nil;
    NSMutableArray *convertSaving = [[NSMutableArray alloc]init];
    
    ExpenditureTrendViewController *ETVC = [[ExpenditureTrendViewController alloc]init];
    
    //First level
    NSMutableArray *savingContainer = [ETVC getExpendAndSaving];
    
    if (!saving)
    {
        //Second Level
        NSMutableArray *currentSaving = [savingContainer objectAtIndex:containerID];
        //Inside of second level which contains the 8 weeks expends
        for(Budget *b in currentSaving)
        {
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
            //Get Budget Category
            NSMutableArray *BClist = [b GetBudgetCategories:b.budget_id];
            
            for(BudgetCategory *bc in BClist)
            {
                if(bc.category_id == catID)
                {
                    if(bc.category_spent != 0)
                    {
                        [convertCategoryExpend addObject:[NSDecimalNumber numberWithDouble:bc.category_spent]];
                    }
                    else
                    {
                        [convertCategoryExpend addObject:[NSDecimalNumber numberWithDouble:0.0]];
                    }
                    //break;
                }
            }
            
            if(convertCategoryExpend.count == 0 || convertCategoryExpend.count < numWeeks.count)
            {
                 [convertCategoryExpend addObject:[NSDecimalNumber numberWithDouble:0.0]];
            }
            
            categoryExpend = convertCategoryExpend;
        }
    }
    return categoryExpend;
}


@end

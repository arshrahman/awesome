//
//  CPDStockPriceStore.h
//  CorePlotDemo
//
//  Created by Steve Baranski on 5/4/12.
//  Copyright (c) 2012 komorka technology, llc. All rights reserved.
//

@interface CPDStockPriceStore : NSObject

+ (CPDStockPriceStore *)sharedInstance;

- (NSArray *)tickerSymbols;

-(NSArray *)EightWeek:(int)containerID;
- (NSArray *)weeklyExpend:(NSString *)tickerSymbol:(int)containerID;
- (NSArray *)weeklySaving:(NSString *)tickerSymbol:(int)containerID;
- (NSArray *)weeklyExpendByCategory:(NSString *)tickerSymbol:(int)containerID:(int)catID;

@end

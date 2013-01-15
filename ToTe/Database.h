//
//  Database.h
//  ToTe
//
//  Created by Abdul Rahman on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

- (void)SetDBPath;
- (void)CreateDB;
- (BOOL)checkBudgetExists;
- (BOOL)InsertWeeklyIncome:(int)income;
- (BOOL) viewPurchases;
- (BOOL)addPurchase:(double)price :(NSString *)category : (NSString *)name;
@end

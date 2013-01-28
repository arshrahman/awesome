//
//  Purchase.h
//  ToTe
//
//  Created by user on 14/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Purchase : NSObject

@property(assign)int uniqueId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *category;
@property(assign)double price;
@property(nonatomic, strong)NSString *date;
@property(assign)int priority;

- (NSMutableArray *) viewTodayPurchases;
-(NSMutableArray *) viewThisWeekPurchases;
- (void)deletePurchase:(int)uniqueId;
- (void)addPurchase:(double)price :(NSString *)category : (NSString *)name: (int)priority;
-(void)updatePurchase:(int)uniqueId :(NSString *)name :(NSString *)category :(double)price: (int)priority;
@end

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
@property(assign)int cateID;
@property(assign)double price;
@property(nonatomic, strong)NSString *date;
@property(assign)int priority;

- (NSMutableArray *) viewTodayPurchases;
-(NSMutableArray *) viewThisWeekPurchases;
- (void)deletePurchase:(int)uniqueId;
- (void)addPurchase:(double)price :(int)category : (NSString *)name: (int)priority;
-(void)updatePurchase:(int)uniqueId :(NSString *)name :(int)category :(double)price: (int)priority;

//pol
- (NSMutableArray *) viewAllPurchases;

@end

//
//  ShoppingTrip.h
//  ToTe
//
//  Created by user on 13/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingTrip : NSObject

//Shopping Item
@property(assign)int shoppingID;
@property(assign)int budgetID;
@property(nonatomic, strong)NSString *shoppingTripName;
@property(nonatomic,strong)NSDate *shoppingDate;
@property(assign)double shoppingBudget;
@property(nonatomic, strong)NSString *Duration;
@property(assign)double shoppingTotal;

@end

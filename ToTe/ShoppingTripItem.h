//
//  ShoppingTripItem.h
//  ToTe
//
//  Created by user on 13/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingTripItem : NSObject

//Shopping Item
@property(assign)int itemID;
@property(assign)int shoppingID;
@property(nonatomic, strong)NSString *shoppingItemName;
@property(nonatomic, strong)NSString *category;
@property(assign)int categoryID;
@property(assign)double shoppingItemPrice;
@property(assign)int necessity;
@property(assign)int check;
@property(nonatomic, strong)NSString *date;

- (NSMutableArray *) viewCurrentShoppingTrip:(int)shoppingID;
- (NSMutableArray *) getShoppingTrip;
- (void)deleteShoppingItem:(int)itemID;
- (void)addshoppingItem:(NSString *)shoppingItemName :(double)shoppingItemPrice :(int)categoryID :(int)necessity: (int)check;
-(void)updateShoppingItem:(int)ItemID :(NSString *)shoppingItemName :(int)categoryID :(double)ShoppngItemPrice: (int)necessity: (int)check;
- (NSMutableArray *) getShoppingTripItem:(int)ID;


@end

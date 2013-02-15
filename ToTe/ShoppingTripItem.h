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
@property(assign)int itemsBought;

- (NSMutableArray *) viewCurrentShoppingTrip:(int)shoppingID;
- (void)deleteShoppingItem:(int)shoppingID :(int)itemID;
- (void)addshoppingItem:(NSString *)shoppingItemName :(double)shoppingItemPrice :(int)categoryID :(int)necessity;
-(void)updateShoppingItem:(int)uniqueId :(NSString *)shoppingItemName :(int)categoryID :(double)ShoppngItemPrice: (int)necessity :(int)itemBought;


@end

//
//  CombinePurchases.h
//  ToTe
//
//  Created by user on 18/3/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CombinePurchases : NSObject

@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *category;
@property(assign)int cateID;
@property(assign)double price;
@property(nonatomic, strong)NSString *date;
@property(assign)int priority;

@end

//
//  BudgetCategory.h
//  ToTe
//
//  Created by Abdul Rahman on 17/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetCategory : NSObject

@property(nonatomic)int budgetCategory_id;
@property(nonatomic)int budget_id;
@property(nonatomic)int category_id;
@property(nonatomic)int category_spent;
@property(nonatomic)int category_amount;
@property(nonatomic)NSString *bcategory_name;
@property(nonatomic)NSString *bcategory_image;

@end

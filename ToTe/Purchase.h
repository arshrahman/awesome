//
//  Purchase.h
//  ToTe
//
//  Created by user on 14/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Purchase : NSObject

@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *category;
@property(assign)double price;
@property(nonatomic, strong)NSDate *date;

@end

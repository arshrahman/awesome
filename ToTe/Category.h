//
//  Category.h
//  ToTe
//
//  Created by Abdul Rahman on 16/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property(nonatomic)NSString *category_name;
@property(nonatomic)NSString *category_image;
@property(nonatomic)int category_id;

-(NSMutableArray *)SelectAllCategory;

@end

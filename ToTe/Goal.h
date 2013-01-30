//
//  Goal.h
//  ToTe
//
//  Created by Abdul Rahman on 29/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goal : NSObject

@property(nonatomic)int goal_id;
@property(nonatomic)NSString *goal_title;
@property(nonatomic)NSString *goal_description;
@property(nonatomic)int *goal_amount;
@property(nonatomic)NSString *deadline;
@property(nonatomic)NSString *goal_photo;
@property(nonatomic)int priority;
@property(nonatomic)int weeks_met;
@property(nonatomic)int amount_tosave;
@property(nonatomic)NSString* goal_start_date;

-(void)InsertGoal:(NSString *)g_title:(NSString *)g_description:(int)g_amount:(NSString *)deadline:(NSString *)g_photo:(int)amount_tosave:(NSString *)g_start_date;
-(NSString *)ConvertDateFormat:(NSString *)end_date;
-(NSString *)getCurrentDay;
-(NSInteger)WeeksBetweenDate:(NSString *)end_date;

@end

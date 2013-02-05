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
@property(nonatomic)int goal_amount;
@property(nonatomic)NSString *deadline;
@property(nonatomic)NSString *goal_photo;
@property(nonatomic)int priority;
@property(nonatomic)int weeks_met;
@property(nonatomic)double amount_tosave;
@property(nonatomic)NSString* goal_start_date;

-(int)InsertGoal:(NSString *)g_title:(NSString *)g_description:(int)g_amount:(NSString *)deadline:(NSString *)g_photo:(double)amount_tosave;
-(NSString *)ConvertDateFormat:(NSString *)end_date;
-(NSString *)getCurrentDay;
-(NSInteger)WeeksBetweenDate:(NSDate *)end_date;
-(NSMutableArray *)SelectAllGoals;
-(NSMutableArray *)SelectGoal:(int)g_id;
-(BOOL)UpdateGoal:(NSString *)g_title:(NSString *)g_description:(int)g_amount:(NSString *)deadline:(NSString *)g_photo:(double)amount_tosave:(int)g_id;
-(BOOL)DeleteGoal:(int)g_id;
-(NSInteger)WeeksBetweenTwoDate:(NSDate *)start_date:(NSDate *)end_date;
-(NSDate *)StringToDate:(NSString *)strDate;
-(NSString *)DateToString:(NSDate *)dt;
-(void)ReorderPriority:(NSMutableArray *)gIdArray;

@end

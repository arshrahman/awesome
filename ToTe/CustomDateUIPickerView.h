//
//  CustomDateUIPickerView.h
//  ToTe
//
//  Created by Pol on 16/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDateUIPickerView: UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;

-(void)SelectToday;

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;


@end

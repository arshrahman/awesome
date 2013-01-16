//
//  ByMonthViewController.h
//  ToTe
//
//  Created by Pol on 16/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomDateUIPickerView;

@interface ByMonthViewController : UIViewController
{
    IBOutlet  UIBarItem *btnCalendar;
}

@property (nonatomic) IBOutlet CustomDateUIPickerView *customDate;

- (IBAction)btnCalender:(id)sender;

@end

//
//  AddGoalViewController.h
//  ToTe
//
//  Created by Abdul Rahman on 28/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGoalViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *addGoalTB;
@property (weak, nonatomic) IBOutlet UITextField *txtGoal;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtDeadline;


- (IBAction)btnDone:(id)sender;

@end

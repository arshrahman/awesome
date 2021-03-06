//
//  UpdateBudgetViewController.h
//  ToTe
//
//  Created by Abdul Rahman on 25/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TPKeyboardAvoidingScrollView;

@interface UpdateBudgetViewController : UIViewController<UIActionSheetDelegate,UITabBarControllerDelegate>
{
    IBOutlet UITableView *budgetCat;
    IBOutlet UILabel *lblBudget;
}
@property (nonatomic) IBOutlet UITableView *budgetCat;
@property (strong, nonatomic) IBOutlet UITextField *txtBudget;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tbWeeklyIncome;

-(IBAction)btnDone:(id)sender;
- (IBAction)btnCancel:(id)sender;


@end

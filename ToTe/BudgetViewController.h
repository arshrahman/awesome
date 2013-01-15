//
//  BudgetViewController.h
//  ToTe
//
//  Created by Abdul Rahman on 13/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetViewController : UIViewController<UIActionSheetDelegate,UITabBarControllerDelegate>
{
    //temporary
    NSArray *data;
    IBOutlet UITableView *budgetCat;
    IBOutlet UILabel *lblBudget;
    IBOutlet UITextField *txtCatValue;
}
@property (nonatomic) IBOutlet UITableView *budgetCat;

@property (weak, nonatomic) IBOutlet UITextField *txtBudget;

@end

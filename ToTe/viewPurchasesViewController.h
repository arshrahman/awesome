//
//  viewPurchasesViewController.h
//  ToTe
//
//  Created by user on 14/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TPKeyboardAvoidingScrollView;
@interface viewPurchasesViewController : UIViewController<UIActionSheetDelegate,UITabBarControllerDelegate>
{
    IBOutlet UITableView *purchaseTV;
    IBOutlet UILabel *lblBudget;
}

@property (nonatomic) IBOutlet UITableView *purchaseTV;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

- (IBAction)Swicth:(id)sender;



@end

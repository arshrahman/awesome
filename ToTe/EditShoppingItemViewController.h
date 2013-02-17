//
//  EditShoppingItemViewController.h
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingTripItem;

@interface EditShoppingItemViewController : UITableViewController<UIActionSheetDelegate,UITabBarControllerDelegate>
{
    int EditStar;
}

@property (nonatomic, strong) ShoppingTripItem *shoppingItem;
@property (weak, nonatomic) IBOutlet UIButton *editCategory;
@property (weak, nonatomic) IBOutlet UITextField *editItemPrice;
@property (weak, nonatomic) IBOutlet UITextField *editItemName;
@property (weak, nonatomic) IBOutlet UIButton *EditStar1;
@property (weak, nonatomic) IBOutlet UIButton *EditStar2;
@property (weak, nonatomic) IBOutlet UIButton *EditStar3;
@property (weak, nonatomic) IBOutlet UIButton *EditStar4;
@property (weak, nonatomic) IBOutlet UIButton *EditStar5;

- (IBAction)Cancel:(id)sender;
- (IBAction)SelectCategory:(id)sender;
-(IBAction)btnUpdate:(id)sender;
-(IBAction)textfieldReutrn:(id)sender;
-(IBAction)starOneClicked:(id)sender;
-(IBAction)starTwoClicked:(id)sender;
-(IBAction)starThreeClicked:(id)sender;
-(IBAction)starFourClicked:(id)sender;
-(IBAction)starFiveClicked:(id)sender;

@end

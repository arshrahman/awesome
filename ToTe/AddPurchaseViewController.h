//
//  AddPurchaseViewController.h
//  ToTe
//
//  Created by user on 20/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@class PurchaseListViewController;
@class PurchaseViewController;

@interface AddPurchaseViewController : UITableViewController<UIActionSheetDelegate>
{
    int AddStar;
}

@property (strong, nonatomic) IBOutlet UITextField *AddItemName;
@property (strong, nonatomic) IBOutlet UITextField *AddItemPrice;
@property (nonatomic, strong) PurchaseListViewController *purchaseListViewController;
@property (nonatomic, strong) PurchaseViewController *purchaseViewController;
@property (strong, nonatomic) IBOutlet UIButton *AddItemCategory;
@property (weak, nonatomic) IBOutlet UIButton *AddStar1;
@property (weak, nonatomic) IBOutlet UIButton *AddStar2;
@property (weak, nonatomic) IBOutlet UIButton *AddStar3;
@property (weak, nonatomic) IBOutlet UIButton *AddStar4;
@property (weak, nonatomic) IBOutlet UIButton *AddStar5;

-(IBAction)starOneClicked:(id)sender;
-(IBAction)starTwoClicked:(id)sender;
-(IBAction)starThreeClicked:(id)sender;
-(IBAction)starFourClicked:(id)sender;
-(IBAction)starFiveClicked:(id)sender;
- (IBAction)SelectCategory:(id)sender;
-(IBAction)cancelPressed:(id)sender;
-(IBAction)donePressed:(id)sender;
-(IBAction)textfieldReutrn:(id)sender;

@end

//
//  EditPurchaseViewController.h
//  ToTe
//
//  Created by user on 20/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Purchase;

@interface EditPurchaseViewController : UITableViewController<UIActionSheetDelegate,UITabBarControllerDelegate>
{
    int EditStar;
}

@property (strong, nonatomic) IBOutlet UITextField *EditItemName;
@property (strong, nonatomic) IBOutlet UITextField *EditItemPrice;
@property (nonatomic, strong) Purchase *purchaseItem;
@property (strong, nonatomic) IBOutlet UIButton *EditItemCategory;
@property (weak, nonatomic) IBOutlet UIButton *EditStar1;
@property (weak, nonatomic) IBOutlet UIButton *EditStar2;
@property (weak, nonatomic) IBOutlet UIButton *EditStar3;
@property (weak, nonatomic) IBOutlet UIButton *EditStar4;
@property (weak, nonatomic) IBOutlet UIButton *EditStar5;

-(IBAction)cancelPressed:(id)sender;
- (IBAction)SelectCategory:(id)sender;
-(IBAction)btnUpdate:(id)sender;
-(IBAction)textfieldReutrn:(id)sender;
-(IBAction)starOneClicked:(id)sender;
-(IBAction)starTwoClicked:(id)sender;
-(IBAction)starThreeClicked:(id)sender;
-(IBAction)starFourClicked:(id)sender;
-(IBAction)starFiveClicked:(id)sender;
@end

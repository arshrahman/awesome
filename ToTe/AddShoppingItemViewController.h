//
//  AddShoppingItemViewController.h
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddShoppingItemViewController : UITableViewController<UIActionSheetDelegate>
{
    int AddStar;
}


@property (strong, nonatomic) IBOutlet UIButton *AddItemCategory;
@property (strong, nonatomic) IBOutlet UITextField *AddItemName;
@property (strong, nonatomic) IBOutlet UITextField *AddItemPrice;
@property (strong, nonatomic) IBOutlet UIButton *AddStar1;
@property (strong, nonatomic) IBOutlet UIButton *AddStar2;
@property (strong, nonatomic) IBOutlet UIButton *AddStar3;
@property (strong, nonatomic) IBOutlet UIButton *AddStar4;
@property (strong, nonatomic) IBOutlet UIButton *AddStar5;

- (IBAction)Cancel:(id)sender;
- (IBAction)SelectCategory:(id)sender;
- (IBAction)TextFieldReturn:(id)sender;
- (IBAction)starOneClicked:(id)sender;
- (IBAction)starTwoClicked:(id)sender;
- (IBAction)starThreeClicked:(id)sender;
- (IBAction)starFourClicked:(id)sender;
- (IBAction)starFiveClicked:(id)sender;
- (IBAction)donePressed:(id)sender;





@end

//
//  EditTripViewController.h
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTripViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSDate *timeline;
    UIActionSheet *dateSheet;
    int numStar;
}

@property (nonatomic, strong)NSMutableArray *ShoppingTripList;
@property (nonatomic, strong)NSMutableArray *ShoppingTripItemList;
@property (weak, nonatomic) IBOutlet UITextField *ShoppingTripTitle;
@property (weak, nonatomic) IBOutlet UITextField *ShoppingTripBudget;
@property (weak, nonatomic) IBOutlet UIButton *ShoppingTripDuration;
@property (weak, nonatomic) IBOutlet UITableView *ShoppingTripItemTV;
@property (nonatomic, retain) NSDate *timeline;

- (IBAction)TimerPicker:(id)sender;
- (IBAction)Cancel:(id)sender;
-(IBAction)textfieldReutrn:(id)sender;
- (IBAction)Done:(id)sender;
- (IBAction)AddItem:(id)sender;
-(void)DoTimeline;
-(void)DismissTimeSet;
-(void)CancelTimeSet;

@end

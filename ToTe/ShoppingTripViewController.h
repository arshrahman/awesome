//
//  ShoppingTripViewController.h
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingTripViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int numStar;
}

@property (nonatomic, strong)NSMutableArray *ShoppingTripList;
@property (nonatomic, strong)NSMutableArray *ShoppingTripItemList;
@property (nonatomic) IBOutlet UITableView *ShoppingTripTV;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *AddTrip;
@property (strong, nonatomic) IBOutlet UIButton *StartEndTrip;
@property (weak, nonatomic) IBOutlet UILabel *lbDuration;
@property (weak, nonatomic) IBOutlet UILabel *lbTripName;
@property (weak, nonatomic) IBOutlet UILabel *lbBudget;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *DeleteTrip;

- (IBAction)DeletePressed:(id)sender;
- (IBAction)StartEndPressed:(id)sender;
- (IBAction)AddPressed:(id)sender;

@end

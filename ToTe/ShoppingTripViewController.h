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
    IBOutlet UITableView *ShoppingItemList;
    int numStar;
}

@property (nonatomic, strong)NSMutableArray *ShoppingTripList;
@property (nonatomic, strong)NSMutableArray *ShoppingTripItemList;
@property (nonatomic) IBOutlet UITableView *ShoppingTripTV;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *AddDeleteTrip;
@property (strong, nonatomic) IBOutlet UIButton *StartEndTrip;

- (IBAction)StartEndPressed:(id)sender;
- (IBAction)AddDeletePressed:(id)sender;

@end

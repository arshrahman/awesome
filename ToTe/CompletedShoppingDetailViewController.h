//
//  CompletedShoppingDetailViewController.h
//  ToTe
//
//  Created by Pol on 22/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletedShoppingViewController.h"

@interface CompletedShoppingDetailViewController : UIViewController

@property (nonatomic, strong) CompletedShoppingViewController *completedShoppingViewController;
@property (nonatomic)int ShoppingTripID;
@property (nonatomic, strong)NSMutableArray *ShoppingTripList;
@property (nonatomic, strong)NSMutableArray *ShoppingTripItemList;
@property (nonatomic) IBOutlet UITableView *ShoppingTripTV;
@property (weak, nonatomic) IBOutlet UILabel *lbDuration;
@property (weak, nonatomic) IBOutlet UILabel *lbTripName;
@property (weak, nonatomic) IBOutlet UILabel *lbBudget;

@end

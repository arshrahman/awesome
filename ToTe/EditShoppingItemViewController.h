//
//  EditShoppingItemViewController.h
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingTripItem.h"

@interface EditShoppingItemViewController : UITableViewController

@property (nonatomic, strong) ShoppingTripItem *ShoppingItem;

- (IBAction)Cancel:(id)sender;

@end

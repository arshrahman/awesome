//
//  PurchasedItemsViewController.h
//  ToTe
//
//  Created by Pol on 1/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchasedItemsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *PurchasedItemsUITableView;
    int numStar;
}

@property (nonatomic) IBOutlet UITableView *PurchasedItemsUITableView;
@property (nonatomic, strong)NSMutableArray *PurchaseList;
@property (nonatomic, strong)NSMutableArray *ShoppingList;
@property (nonatomic, strong)NSMutableArray *CombineList;
@property (nonatomic, strong)NSMutableArray *PurchaseListCategory;
@property (nonatomic, strong)NSMutableArray *PurchaseListPrice;

-(void)Refresh;

@end

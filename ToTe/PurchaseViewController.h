//
//  PurchaseViewController.h
//  ToTe
//
//  Created by user on 24/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *PurchaseTableView;
    int numStar;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *SortBy;
@property (nonatomic, strong)NSMutableArray *PurchaseList;
@property (nonatomic, strong)NSMutableArray *PurchaseListWeek;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Edit;
@property (nonatomic) IBOutlet UITableView *PurchaseTableView;

- (IBAction)btnEdit:(id)sender;
- (IBAction)Switch:(id)sender;
@end

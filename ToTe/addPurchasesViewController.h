//
//  addPurchasesViewController.h
//  ToTe
//
//  Created by user on 8/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addPurchasesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *Categories;
@property (weak, nonatomic) IBOutlet UITextField *Price;
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Done;

- (IBAction)Done:(id)sender;

@end

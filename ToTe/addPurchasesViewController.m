//
//  addPurchasesViewController.m
//  ToTe
//
//  Created by user on 8/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "addPurchasesViewController.h"
#import "Database.h"

@interface addPurchasesViewController ()

@end

@implementation addPurchasesViewController

@synthesize Categories;
@synthesize Price;
@synthesize Name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCategories:nil];
    [self setPrice:nil];
    [self setName:nil];
    [super viewDidUnload];
}

//When user click on Done button
- (IBAction)Done:(id)sender {
    NSLog(@"Done event triggered!");
    Database *db = [[Database alloc]init];
    
    NSString *stringValue = Price.text;
    NSString *convertPrice = [NSString stringWithFormat:@"%.2f",[stringValue doubleValue]/(double)100.00];
    
    [db addPurchase:convertPrice.doubleValue :Categories.text :Name.text];
    
}

@end

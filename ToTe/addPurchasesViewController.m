//
//  addPurchasesViewController.m
//  ToTe
//
//  Created by user on 8/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "addPurchasesViewController.h"
#import "Database.h"
#import "Category.h"

@interface addPurchasesViewController ()
{
    //NSMutableArray *data;
    NSMutableArray *otherButtons;
}

@end

@implementation addPurchasesViewController

@synthesize btnCate;
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
    //data = [[NSMutableArray alloc]init];
    Category *c = [[Category alloc]init];
    otherButtons = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        //NSLog(@"Category: %d, %@, %@", cc.category_id, cc.category_name, cc.category_image);
        [otherButtons addObject:cc];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPrice:nil];
    [self setName:nil];
    [self setDone:nil];
    [self setBtnCate:nil];
    [super viewDidUnload];
}

//When user click on Done button
- (IBAction)Done:(id)sender {
    NSLog(@"Done event triggered!");
    Database *db = [[Database alloc]init];
    
    NSString *stringValue = Price.text;
    NSString *convertPrice = [NSString stringWithFormat:@"%2f",[stringValue doubleValue]/(double)100.00];
    
    [db addPurchase:convertPrice.doubleValue :btnCate.currentTitle :Name.text];
    
    // BudgetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BudgetViewController"];
    // [self.navigationController pushViewController:svc animated:YES];
    
}

- (IBAction)SelectCat:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Categories" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for(Category *c in otherButtons)
    {
        [as addButtonWithTitle:c.category_name];
    }
    
    [as showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Category *c = [otherButtons objectAtIndex:buttonIndex];
    //[data addObject:c.category_name];
    [btnCate setTitle:c.category_name forState:UIControlStateNormal];
    //[[self budgetCat]reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

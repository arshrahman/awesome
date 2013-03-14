//
//  ShoppingTripViewController.m
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ShoppingTripViewController.h"
#import "ShoppingTrip.h"
#import "ShoppingTripItem.h"
#import "EditShoppingItemViewController.h"
#import "customCell2.h"
#import "customCell1.h"

@interface ShoppingTripViewController ()
{
    ShoppingTrip *st;
    ShoppingTripItem *shoppingItem;
    NSMutableArray *isCheckedArr;
}

@end

@implementation ShoppingTripViewController

@synthesize ShoppingTripItemList;
@synthesize ShoppingTripList;
@synthesize ShoppingTripTV;
@synthesize AddTrip;
@synthesize StartEndTrip;
@synthesize lbBudget;
@synthesize lbDuration;
@synthesize lbTripName;
@synthesize Extend;

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
    
    //load it once
    NSLog(@"Shopping Trip");
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //AppKilled
    /*
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AppKilled"])
    {
        [self setTimer];
    }
     */
    
    //Retrieve Data
    st = [[ShoppingTrip alloc]init];
    ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
    
    st = [st checkShoppingTrip];
    self.ShoppingTripItemList = [sti viewCurrentShoppingTrip:st.shoppingID];
    
    [self.ShoppingTripTV reloadData];
    
    NSLog(@"%d",self.ShoppingTripItemList.count);
    
    if(st.shoppingID != 0)
    {
        //use split here
        
        self.lbBudget.text = [NSString stringWithFormat: @"$%.2lf", st.shoppingBudget];
        self.lbTripName.text = st.shoppingTripName;
    }
    
    if(self.ShoppingTripItemList.count > 0)
    {
        //Not Started - 0
        //Progressing - 1
        //Completed - 2
        //Ended but not complete - 3
        NSLog(@"%d", st.shoppingTripCompleted);
        if(st.shoppingTripCompleted == 0)
        {
            [self.StartEndTrip setTitle:@"Start Trip" forState:UIControlStateNormal];
            self.StartEndTrip.hidden = FALSE;
            
            //Only When user have not start the trip
            self.lbDuration.text = st.Duration;
            
        }
        else if(st.shoppingTripCompleted == 1)
        {
            [self.StartEndTrip setTitle:@"End Trip" forState:UIControlStateNormal];
            self.StartEndTrip.hidden = FALSE;
        }
        else if(st.shoppingTripCompleted == 3)
        {
            [self.StartEndTrip setTitle:@"Confirm Trip" forState:UIControlStateNormal];
            self.StartEndTrip.hidden = FALSE;
        }
    }
    else
    {
        self.StartEndTrip.hidden = TRUE;
    }
    
    if(self.ShoppingTripItemList.count == 0)
    {
        self.AddTrip.enabled =TRUE;
        self.DeleteTrip.enabled =FALSE;
    }
    else
    {
        self.AddTrip.enabled = FALSE;
        self.DeleteTrip.enabled =TRUE;
    }
    
    isCheckedArr = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[self.ShoppingTripItemList count]; i++) {
        [isCheckedArr addObject:@"0"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.ShoppingTripItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if(st.shoppingTripCompleted == 0){
        
        customCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell ==nil)
        {
            cell = [[customCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        ShoppingTripItem *currentItem = [[ShoppingTripItem alloc]init];
        currentItem = [self.ShoppingTripItemList objectAtIndex:indexPath.row];
    
        // Configure the cell...
        cell.customCellItemName.text = currentItem.shoppingItemName;
        cell.customCellItemPrice.text = [NSString stringWithFormat: @"$%.2lf", currentItem.shoppingItemPrice];
        cell.customCellItemCategory.text = currentItem.category;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    
        //NSLog([NSString stringWithFormat: @"%d", currentPurchaseItem.priority]);
        if(currentItem.necessity == 5)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        }
        else if(currentItem.necessity == 4)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else if(currentItem.necessity == 3)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else if(currentItem.necessity == 2)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else if(currentItem.necessity == 1)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        
        return cell;
    }
    else
    {
        customCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell ==nil)
        {
            cell = [[customCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ShoppingTripItem *currentItem = [[ShoppingTripItem alloc]init];
        currentItem = [self.ShoppingTripItemList objectAtIndex:indexPath.row];
        
        // Configure the cell...
        cell.customCellItemName.text = currentItem.shoppingItemName;
        cell.customCellItemPrice.text = [NSString stringWithFormat: @"$%.2lf", currentItem.shoppingItemPrice];
        cell.customCellItemCategory.text = currentItem.category;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        [cell.checkBox setTag:indexPath.row];
        
        [cell.checkBox addTarget:self action:@selector(CheckBoxTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[isCheckedArr objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            [cell.checkBox setImage:[UIImage imageNamed:@"glyphicons_152_check.png"] forState:UIControlStateNormal];
            currentItem.check = 1;
        }
        else
        {
            [cell.checkBox setImage:[UIImage imageNamed:@"glyphicons_153_unchecked.png"] forState:UIControlStateNormal];
            currentItem.check = 0;
        }
        
        //NSLog([NSString stringWithFormat: @"%d", currentPurchaseItem.priority]);
        if(currentItem.necessity == 5)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
        }
        else if(currentItem.necessity == 4)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else if(currentItem.necessity == 3)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else if(currentItem.necessity == 2)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else if(currentItem.necessity == 1)
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_049_star.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        else
        {
            cell.Star1.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star2.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star3.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star4.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
            cell.Star5.image = [UIImage imageNamed:@"glyphicons_048_dislikes.png"];
        }
        
        return cell;
    }
}

-(IBAction)CheckBoxTapped:(id)sender
{
    //check
    if ([[isCheckedArr objectAtIndex:[sender tag]] isEqualToString:@"0"]) {
        
        [isCheckedArr replaceObjectAtIndex:[sender tag] withObject:@"1"];
        
        ShoppingTripItem *s = [self.ShoppingTripItemList objectAtIndex:[sender tag]];
        s.check = 1;
        [s updateShoppingItem:s.itemID :s.shoppingItemName :s.categoryID :s.shoppingItemPrice :s.necessity :s.check];
        
    }
    //uncheck
    else if ([[isCheckedArr objectAtIndex:[sender tag]] isEqualToString:@"1"]) {
        [isCheckedArr replaceObjectAtIndex:[sender tag] withObject:@"0"];
        
        ShoppingTripItem *s = [self.ShoppingTripItemList objectAtIndex:[sender tag]];
        s.check = 2;
        [s updateShoppingItem:s.itemID :s.shoppingItemName :s.categoryID :s.shoppingItemPrice :s.necessity :s.check];
    }
    
    [self.ShoppingTripTV reloadData];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    EditShoppingItemViewController *editingView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditShoppingItemViewController"];
    
    editingView.shoppingItem = [self.ShoppingTripItemList objectAtIndex:tableView.indexPathForSelectedRow.row];
    
    [editingView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    // Pass the selected object to the new view controller.
    [self presentModalViewController:editingView animated:YES];
    //[self.navigationController pushViewController:editingView animated:YES];
}

- (void)viewDidUnload {
    [self setShoppingTripTV:nil];
    [self setAddTrip:nil];
    [self setStartEndTrip:nil];
    [self setLbDuration:nil];
    [self setLbTripName:nil];
    [self setLbBudget:nil];
    [self setDeleteTrip:nil];
    [super viewDidUnload];
}

- (IBAction)DeletePressed:(id)sender {
    
    StopTime = TRUE;
    [self setTimer];
    
    [st deleteShoppingTrip:st.shoppingID];
    [self.ShoppingTripItemList removeAllObjects];
    self.lbDuration.text = @"Duration";
    self.lbBudget.text = @"Budget";
    self.lbTripName.text = @"Trip Name";
    [self.ShoppingTripTV reloadData];
    lbDuration.textColor = [UIColor blackColor];
    
    self.StartEndTrip.hidden = TRUE;

    if(self.ShoppingTripItemList.count == 0)
    {
        self.AddTrip.enabled =TRUE;
        self.DeleteTrip.enabled =FALSE;
    }
    else
    {
        self.AddTrip.enabled = FALSE;
        self.DeleteTrip.enabled =TRUE;
    }
}

- (IBAction)StartEndPressed:(id)sender {
    //Start and End Trip
    if([self.StartEndTrip.titleLabel.text isEqualToString:@"Start Trip"])
    {
        //Duration count down timer start
        StopTime = FALSE;
        [self setTimer];
        st.shoppingTripCompleted = 1;
        [st updateShoppingTrip:st.shoppingID :st.shoppingTripCompleted];
        [self.StartEndTrip setTitle:@"End Trip" forState:UIControlStateNormal];
        [self.ShoppingTripTV reloadData];
    }
    else if([self.StartEndTrip.titleLabel.text isEqualToString:@"End Trip"])
    {
        //Duration count down stop
        StopTime = TRUE;
        [self setTimer];
        st.shoppingTripCompleted = 3;
        [st updateShoppingTrip:st.shoppingID :st.shoppingTripCompleted];
        [self.StartEndTrip setTitle:@"Confirm Trip" forState:UIControlStateNormal];
        lbDuration.textColor = [UIColor blackColor];
    }
    else
    {
        //Update Shopping Trip and Shopping Trip item
        //Update Shopping Trip and set ShoppingTripCompleted to TRUE
        st.shoppingTripCompleted = 2;
        [st updateShoppingTrip:st.shoppingID :st.shoppingTripCompleted];
        
        for(ShoppingTripItem *item in self.ShoppingTripItemList)
        {
            //delete unchecked item in the database
            if(item.check == 0)
            {
                [item deleteShoppingItem:item.itemID];
            }
        }
        
        [self.ShoppingTripItemList removeAllObjects];
        self.lbDuration.text = @"Duration";
        self.lbBudget.text = @"Budget";
        self.lbTripName.text = @"Trip Name";
        [self.ShoppingTripTV reloadData];
        self.StartEndTrip.hidden = TRUE;
        self.AddTrip.enabled = TRUE;
        self.DeleteTrip.enabled = FALSE;
    }
}

- (IBAction)AddPressed:(id)sender {
    
    //Add and Delete Trip
    //[self.EditItemCategory setTitle:c.category_name forState:UIControlStateNormal];
}

-(void)timerRun {
    
    int sec;
    int min;
    int hr;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"TimeCheck"])
    {
        int TimeSpan = [[NSUserDefaults standardUserDefaults] integerForKey:@"TimeSpan"];
        
        NSLog(@"%d",TimeSpan);
        
        if(secondsCount > TimeSpan)
        {
            secondsCount = secondsCount - TimeSpan;
            sec = secondsCount%60;
            min = (secondsCount/60)%60;
            hr = (secondsCount/3600)%60;
        }
        else
        {
            secondsCount = 0;
            sec = secondsCount%60;
            min = (secondsCount/60)%60;
            hr = (secondsCount/3600)%60;
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TimeCheck"];
    }
    else
    {
        secondsCount = secondsCount - 1;
        sec = secondsCount%60;
        min = (secondsCount/60)%60;
        hr = (secondsCount/3600)%60;
    }
    
    //20 min - turn red
    if(min < 20)
    {
        lbDuration.textColor = [UIColor redColor];
    }
    
    if(secondsCount == 0)
    {
        [countdownTimer invalidate];
        countdownTimer = nil;
        
        //Message
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duration"message:@"Time Allocated For This Shopping Trip Is Up!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Extend Trip",@"End Trip", nil];
        
        alert.tag = 1;
        [alert show];
    }
    
    NSString *timerOutput = [NSString stringWithFormat:@"%02d:%02d:%02d", hr, min, sec];
    
    self.lbDuration.text = timerOutput;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    NSString *alertButton = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(alertView.tag == 1)
    {
        if ([alertButton isEqualToString:@"End Trip"]) {
            NSLog(@"End Trip");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duration"message:@"Are you sure you want to end the Trip?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"Cancel", nil];
            alert.tag = 2;
            [alert show];
        }
        else if([alertButton isEqualToString:@"Extend Trip"])
        {
            NSLog(@"Extend Trip");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duration"message:@"Are you sure you want to extend the Trip?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"Cancel", nil];
            alert.tag = 3;
            [alert show];
        }
    }
    //End Trip
    else if(alertView.tag == 2)
    {
        if ([alertButton isEqualToString:@"Yes"]) {
            [StartEndTrip sendActionsForControlEvents: UIControlEventTouchUpInside];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duration"message:@"Time Allocated For This Shopping Trip Is Up!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Extend Trip",@"End Trip", nil];
            
            alert.tag = 1;
            [alert show];
        }
    }
    //Extend Trip
    else if(alertView.tag == 3)
    {
        if ([alertButton isEqualToString:@"Yes"]) {
            lbDuration.text = @"00:05:00";
            [self setTimer];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duration"message:@"Time Allocated For This Shopping Trip Is Up!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Extend Trip",@"End Trip", nil];
            
            alert.tag = 1;
            [alert show];
        }
    }
}

-(void)setTimer {
    
    if(StopTime == TRUE)
    {
        if (countdownTimer) {
            [countdownTimer invalidate];
            countdownTimer = nil;
        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Time"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Time"];
        //secondsCount = 3600;
        NSArray* time = [lbDuration.text componentsSeparatedByString: @":"];
        NSString* HH = [time objectAtIndex: 0];
        NSString* MM = [time objectAtIndex: 1];
        
        NSInteger ConvertHH = [HH integerValue];
        NSInteger ConvertMM = [MM integerValue];
        
        ConvertHH = ConvertHH * 3600;
        ConvertMM = ConvertMM * 60;
        
        secondsCount = ConvertHH + ConvertMM;
    
        /*
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"AppKilled"])
        {
            secondsCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"AppGottenKilled"];
        }
         */
        
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
}
@end

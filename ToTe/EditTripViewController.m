//
//  EditTripViewController.m
//  ToTe
//
//  Created by Pol on 6/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "EditTripViewController.h"
#import "AddShoppingItemViewController.h"
#import "ShoppingTripItem.h"
#import "ShoppingTrip.h"
#import "EditShoppingItemViewController.h"
#import "customCell.h"

@interface EditTripViewController ()

@end

@implementation EditTripViewController

@synthesize timeline;
@synthesize ShoppingTripBudget;
@synthesize ShoppingTripDuration;
@synthesize ShoppingTripItemTV;
@synthesize ShoppingTripTitle;
@synthesize ShoppingTripItemList = _ShoppingTripItemList;
@synthesize ShoppingTripList = _ShoppingTripList;

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
    
    NSLog(@"Edit Shopping Trip");
    [self DoTimeline];
    self.ShoppingTripItemList = [[NSMutableArray alloc]init];
    self.ShoppingTripList = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tap];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShoppingTripTitle:nil];
    [self setShoppingTripBudget:nil];
    [self setShoppingTripDuration:nil];
    [self setShoppingTripItemTV:nil];
    [super viewDidUnload];
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
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell ==nil)
    {
        cell = [[customCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         ShoppingTripItem *s = [self.ShoppingTripItemList objectAtIndex:indexPath.row];
         //Call database method
         [s deleteShoppingItem:s.itemID];
         
         // Delete the row from the data source
         [self.ShoppingTripItemList removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }
 

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
    EditShoppingItemViewController *editingView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditShoppingItemViewController"];
    
    editingView.ShoppingItem = [self.ShoppingTripItemList objectAtIndex:tableView.indexPathForSelectedRow.row];
    
    [editingView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    // Pass the selected object to the new view controller.
    [self presentModalViewController:editingView animated:YES];
}

- (IBAction)TimerPicker:(id)sender {
    [self dismissKeyboard];
    [dateSheet showInView:self.view];
    [dateSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (IBAction)Cancel:(id)sender {
    //remove all items using it's shopping id
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)Done:(id)sender {
    
    //Add shopping Trip and shopping Trip Item
    ShoppingTrip *st = [[ShoppingTrip alloc]init];
    ShoppingTripItem *sti = [[ShoppingTripItem alloc]init];
    
    NSString *checkTripName = self.ShoppingTripTitle.text;
    //NSString checkTripDuration = self.ShoppingTripDuration.text;
    NSString *checkTripBudget = self.ShoppingTripBudget.text;
    
    //Shopping Trip total item price
    double i = 0;
    for(ShoppingTripItem *item in self.ShoppingTripItemList)
    {
        i = i + item.shoppingItemPrice;
    }
    
    st.shoppingTotal = i;
    /*
    if([checkTripName length] == 0 && ([checkTripBudget length] == 0 || [checkTripBudget doubleValue] == 0) && ([ShoppingTripDuration.titleLabel.text isEqualToString:@"Duration"] || [ShoppingTripDuration.titleLabel.text isEqualToString:@"00:00:00"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the Trip Name, the Duration and the Budget for the Trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if(([checkTripBudget length] == 0 || [checkTripBudget doubleValue] == 0) && ([ShoppingTripDuration.titleLabel.text isEqualToString:@"Duration"] || [ShoppingTripDuration.titleLabel.text isEqualToString:@"00:00:00"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the Duration and the Budget for the Trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
     */
    //else
    if([checkTripName length] == 0 && ([ShoppingTripDuration.titleLabel.text isEqualToString:@"Duration"] || [ShoppingTripDuration.titleLabel.text isEqualToString:@"00:00:00"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the Trip Name and the Duration of the Trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    /*
    else if([checkTripName length] == 0 && ([checkTripBudget length] == 0 || [checkTripBudget doubleValue] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the Trip Name and the Budget for the Trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if([checkTripBudget length] == 0 || [checkTripBudget doubleValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the Budget for the Trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
     */
    else if([checkTripName length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the Trip Name!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else if(self.ShoppingTripItemList.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please add at least one item for the Trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    /*
    else if(i > [checkTripBudget doubleValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Insufficient budget: Please increase the amount of your shopping budget!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
     */
    else if(([ShoppingTripDuration.titleLabel.text isEqualToString:@"Duration"] || [ShoppingTripDuration.titleLabel.text isEqualToString:@"00:00:00"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Trip"message:@"Please specify the duration of your shopping!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Shopping Trip Name
        st.shoppingTripName = ShoppingTripTitle.text;
    
        //Shopping Trip Budget
        st.shoppingBudget = [ShoppingTripBudget.text doubleValue];

        //Shopping Trip Duration
        st.Duration = self.ShoppingTripDuration.currentTitle;
        
        //Current Date
        st.shoppingDate = [NSDate date];
        
        st.shoppingTripCompleted = 0;
    
        //call database code
        //Add Trip
        [st addshoppingTrip:st.shoppingTripName :st.shoppingBudget :st.Duration :st.shoppingTotal :st.shoppingTripCompleted];
        
        NSLog(@"WENT IN TO THE LOOP");
        NSLog(@"%d", self.ShoppingTripItemList.count);
        for(ShoppingTripItem *item in self.ShoppingTripItemList)
        {
            //add item into database
            item.check = 0;
            [sti addshoppingItem:item.shoppingItemName :item.shoppingItemPrice :item.categoryID :item.necessity :item.check];
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)AddItem:(id)sender {
    [self.ShoppingTripBudget resignFirstResponder];
    [self.ShoppingTripTitle resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddShoppingItem"]){
        NSLog(@"push to editTripViewController");
        UINavigationController *nav = segue.destinationViewController;
        
        AddShoppingItemViewController *add = [nav.viewControllers objectAtIndex:0];
        add.editTripViewController = self;
    }
    
    //else if([segue.identifier isEqualToString:@"EditItem"])
    //{
    //NSLog(@"push to EditPurchaseViewController");
    //edit.purchaseItem = self;
    //EditPurchaseViewController *editPuchase = segue.destinationViewController;
    
    //editPuchase.purchaseItem = [self.PurchaseList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    //EditPurchaseViewController *editPuchase = segue.destinationViewController;
    //editPuchase.purchaseItem = [self.PurchaseList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    //}
    //NSLog(segue.identifier);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.ShoppingTripItemTV reloadData];
    
    double i = 0;
    for(ShoppingTripItem *item in self.ShoppingTripItemList)
    {
        i = i + item.shoppingItemPrice;
    }

    ShoppingTripBudget.text = [NSString stringWithFormat:@"%.2lf", i];
}

-(IBAction)textfieldReutrn:(id)sender
{
    [sender resignFirstResponder];
}

-(void)DoTimeline
{
    dateSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [dateSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    
    // Create a new date with the current time
    //NSDate *date = [NSDate new];
    // Split up the date components
    //NSDateComponents *time = [[NSCalendar currentCalendar]
                              //components:NSHourCalendarUnit | NSMinuteCalendarUnit
                              //fromDate:date];
    
    NSInteger seconds = (0 * 60 * 60) + (1 * 60);
    
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:pickerFrame];
    [picker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [picker setCountDownDuration:seconds];
    
    [dateSheet addSubview:picker];
    
    UIToolbar *controlBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, dateSheet.bounds.size.width, 44)];
    [[UIToolbar appearance] setTintColor:[UIColor lightGrayColor]];
    
    [controlBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc]initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(DismissTimeSet)];
    [setButton setTintColor:[UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(255/255.0) alpha:1]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelTimeSet)];
    [cancelButton setTintColor:[UIColor colorWithRed:(230/255.0) green:(0/255.0) blue:(0/255.0) alpha:1]];
    
    [controlBar setItems:[NSArray arrayWithObjects:spacer, cancelButton, setButton, nil] animated:YES];
    
    
    [dateSheet addSubview:controlBar];
}


-(void)DismissTimeSet
{
    NSArray *listOfViews = [dateSheet subviews];
    
    NSDateComponents* result = [[NSDateComponents alloc]init];
    int Hour = 0;
    int Min = 0;
    NSString *Dura = [[NSString alloc] init];
    
    for(UIView *subView in listOfViews)
    {
        
        if([subView isKindOfClass:[UIDatePicker class]])
        {
            self.timeline = [(UIDatePicker *)subView date];
            
            NSLog(@"Time:");
            
            NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
             result = [cal components:NSHourCalendarUnit |
                                        NSMinuteCalendarUnit
                                              fromDate:self.timeline];
            
            NSLog(@"%d hours, %d minutes",
                  [result hour], [result minute]);
            
            Hour = [result hour];
            Min = [result minute];
            
            NSLog(@"%d", Min);
        }
    }
    
    if(Hour > 4 || (Hour == 4 && Min > 0))
    {
        Hour = 4;
        Min = 0;
        
        //Messge
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shopping Trip Duration"message:@"The maximum hours you can have is up till 4 hour per shopping trip!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    
    Dura = [NSString stringWithFormat:@"%02d:%02d:00", Hour, Min];
    [self.ShoppingTripDuration setTitle:Dura forState:UIControlStateNormal];
    
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)CancelTimeSet
{
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


@end

//
//  AddGoalViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 28/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "AddGoalViewController.h"
#import "Goal.h"
#import "GoalDetailViewController.h"
#import "GoalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddGoalViewController ()

@end

@implementation AddGoalViewController
{
    UIImage *image;
    NSData *imageData;
    NSString *oldPhotoName;
    Goal *g;
    double toSave;
}

@synthesize txtGoal;
@synthesize txtDescription;
@synthesize txtAmount;
@synthesize txtDeadline;
@synthesize deadline;
@synthesize addGoalTB;
@synthesize photoView;
@synthesize photoLabel;
@synthesize lblSave;

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
	
    g = [[Goal alloc]init];
    
    [self DoDeadline];
    
    oldPhotoName = @"";
    
    txtGoal.tag = 100;
    txtDescription.tag = 200;
    txtAmount.tag = 300;
    txtDeadline.tag = 400;
        
    photoView.layer.cornerRadius = 5.0;
    photoView.clipsToBounds = YES;
    
    btnCancel.hidden = TRUE;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tap];
    
    [txtAmount addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeKeyboard:)];
    leftSwipeGestureRecognizer.numberOfTouchesRequired = 1;
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [addGoalTB addGestureRecognizer:leftSwipeGestureRecognizer];
    
    //addGoalTB.scrollEnabled = NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row ==0)
    {
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        self.imagePicker.allowsEditing = YES;
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        imageData = UIImagePNGRepresentation(image);
        
        NSString *photoName = [NSString stringWithFormat:@"%@.png", [self getImageName]];
        [imageData writeToFile:[self documentsPathForFileName:photoName] atomically:YES];
        
        if ([oldPhotoName length] > 0)
        {
            [self removeImage:oldPhotoName];
        }
        oldPhotoName = photoName;
    }
    
    photoView.image = image;
    photoLabel.text = @"Edit photo";
    btnCancel.hidden = FALSE;
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (void)removeImage:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"Images/%@", fileName]];
    
    NSError *error = nil;
    if(![fileManager removeItemAtPath: documentsPath error:&error])
    {
        NSLog(@"Delete failed:%@", error);
    }
    else
    {
        //NSLog(@"image removed: %@", documentsPath);
    }
}

-(NSString*)getImageName
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *now = [NSDate date];
    
    return [format stringFromDate:now];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 400)
    {
        [self.view endEditing:YES];
        [dateSheet showFromTabBar:self.tabBarController.tabBar];
        [dateSheet setBounds:CGRectMake(0, 0, 320, 485)];
        return NO;
    }
    else
    {
        return YES;
    }
}


-(void)textEditingChanged:(UITextField *)textField
{
    if([txtDeadline.text length] > 0 && [txtAmount.text length] > 0)
    {
        [self ChangelblSave];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"Check");
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length > 51)
        {
            textField.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1];
            textField.layer.cornerRadius = 7.0f;
            textField.layer.masksToBounds = YES;
            textField.layer.borderColor=[[UIColor redColor]CGColor];
            textField.layer.borderWidth= 2.0f;
            return NO;
        }
        else
        {
            textField.layer.borderColor = [[UIColor clearColor]CGColor];
            textField.backgroundColor = [UIColor clearColor];
            return YES;
        }

    }
    else
    {
        return YES;
    }
}


-(void)dismissKeyboard
{
    NSLog(@"Check 2");
    [self.view endEditing:YES];
}


- (void)SwipeKeyboard:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    NSLog(@"Check 3");
    [self.view endEditing:YES];
}


-(void)ChangelblSave
{
    int weeks = [g WeeksBetweenDate:self.deadline];
    double amount = [txtAmount.text doubleValue];
    
    toSave = amount/(double)weeks;
    
    if (toSave != (int)toSave)
    {
        toSave = [[NSString stringWithFormat:@"%.2f",toSave] doubleValue];
    }
    
    lblSave.text = [NSString stringWithFormat:@"Save $%.2f per week", toSave];
}


-(void)DoDeadline
{
    [self dismissKeyboard];
    dateSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [dateSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    UIDatePicker *deadlinePicker = [[UIDatePicker alloc]initWithFrame:pickerFrame];
    
    [deadlinePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale currentLocale]];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [df stringFromDate:[NSDate date]];
    NSDate* currentDate = [df dateFromString:strDate];
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    
    [comps setDay:1];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    
    [comps setYear: 3];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    
    deadlinePicker.minimumDate = minDate;
    deadlinePicker.maximumDate = maxDate;
    deadlinePicker.date = minDate;
    
    [dateSheet addSubview:deadlinePicker];
    
    UIToolbar *controlBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, dateSheet.bounds.size.width, 44)];
    [[UIToolbar appearance] setTintColor:[UIColor lightGrayColor]];
    
    [controlBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc]initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(DismissDateSet)];
    [setButton setTintColor:[UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(255/255.0) alpha:1]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelDateSet)];
    [cancelButton setTintColor:[UIColor colorWithRed:(230/255.0) green:(0/255.0) blue:(0/255.0) alpha:1]];
    
    [controlBar setItems:[NSArray arrayWithObjects:spacer, cancelButton, setButton, nil] animated:YES];
    
    
    [dateSheet addSubview:controlBar];
}


-(void)DismissDateSet
{
    NSArray *listOfViews = [dateSheet subviews];
    
    for(UIView *subView in listOfViews)
    {
        if([subView isKindOfClass:[UIDatePicker class]])
        {
            self.deadline = [(UIDatePicker *)subView date];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [txtDeadline setText:[dateFormatter stringFromDate:self.deadline]];
    
    if([txtAmount.text length] > 0)[self ChangelblSave];
    
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)CancelDateSet
{
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(BOOL)IsNotEmpty:(NSString *)txt
{
    if([txt length] > 0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}


- (IBAction)btnDone:(id)sender
{
    if ([self IsNotEmpty:txtGoal.text] && [self IsNotEmpty:txtAmount.text] && [self IsNotEmpty:txtDeadline.text])
    {
        NSString *strDeadline = [g DateToString:self.deadline];
        int goalID = 0;
        goalID = [g InsertGoal:txtGoal.text :txtDescription.text :[txtAmount.text doubleValue] :strDeadline :oldPhotoName :toSave];
        
        //nsusedefault with goal id
        [[NSUserDefaults standardUserDefaults]setInteger:goalID forKey:@"NewGoal"];
        
        if (goalID > 0)
        {            
            GoalViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoalViewController"];
            [self.navigationController pushViewController:gvc animated:YES];
        }
    }
    else
    {
        if (![self IsNotEmpty:txtGoal.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal"message:@"Please fill in the goal title!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];

        }
        else if (![self IsNotEmpty:txtAmount.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal"message:@"Please fill in the goal amount!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];

        }
        else if (![self IsNotEmpty:txtDeadline.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal"message:@"Please fill in the deadline!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (IBAction)btnCancel:(id)sender
{
    [self removeImage:oldPhotoName];
    oldPhotoName = @"";
    photoView.image = [UIImage imageNamed:@"camera-icon-md.png"];
    photoLabel.text = @"Add photo";
    btnCancel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAddGoalTB:nil];
    [self setTxtGoal:nil];
    [self setTxtDescription:nil];
    [self setTxtAmount:nil];
    [self setTxtDeadline:nil];
    [self setDeadline:nil];
    [self setPhotoView:nil];
    [self setPhotoLabel:nil];
    btnCancel = nil;
    [self setLblSave:nil];
    [super viewDidUnload];
}

@end

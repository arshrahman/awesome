//
//  AddGoalViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 28/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "AddGoalViewController.h"
#import "Goal.h"
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
    int toSave;
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
    
    oldPhotoName = @"";
    
    txtGoal.tag = 100;
    txtDescription.tag = 200;
    txtAmount.tag = 300;
    txtDeadline.tag = 400;
    
    txtDescription.backgroundColor = [UIColor clearColor];
    txtDescription.textColor = [UIColor lightGrayColor];
    txtDescription.text = @"Goal Description";
    
    photoView.layer.cornerRadius = 5.0;
    photoView.clipsToBounds = YES;
    
    btnCancel.hidden = TRUE;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tap];
    
    [txtAmount addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[cell setUserInteractionEnabled:NO];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        //[cell setUserInteractionEnabled:YES];
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


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    txtDescription.text = @"";
    txtDescription.textColor = [UIColor blackColor];
    return YES;
}


-(void) textViewDidChange:(UITextView *)textView
{
    if(txtDescription.text.length == 0)
    {
        txtDescription.textColor = [UIColor lightGrayColor];
        txtDescription.text = @"Goal Description";
        //[txtDescription resignFirstResponder];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        txtDescription.textColor = [UIColor lightGrayColor];
        txtDescription.text = @"Goal Description";
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 400)
    {
        [self.view endEditing:YES];
        [self DoDeadline];
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
    
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)ChangelblSave
{
    int weeks = [g WeeksBetweenDate:txtDeadline.text];
    int amount = [txtAmount.text intValue];
    toSave = amount/weeks;
    lblSave.text = [NSString stringWithFormat:@"Save $%d per week", toSave];
}


-(void)DoDeadline
{
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
    [dateSheet showFromTabBar:self.tabBarController.tabBar];
    [dateSheet setBounds:CGRectMake(0, 0, 320, 485)];
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

-(BOOL)IsEmpty:(NSString *)txt
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
    if ([self IsEmpty:txtGoal.text] && [self IsEmpty:txtAmount.text] && [self IsEmpty:txtDeadline.text])
    {
        NSString *strDeadline = [g ConvertDateFormat:txtDeadline.text];
        
        if ([g InsertGoal:txtGoal.text :txtDescription.text :[txtAmount.text intValue] :strDeadline :oldPhotoName :toSave])
        {
            GoalViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoalViewController"];
            [self.navigationController pushViewController:gvc animated:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal"message:@"Please fill in all the fields!" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
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

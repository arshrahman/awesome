//
//  AddGoalViewController.m
//  ToTe
//
//  Created by Abdul Rahman on 28/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "AddGoalViewController.h"

@interface AddGoalViewController ()

@end

@implementation AddGoalViewController
@synthesize txtGoal;
@synthesize txtDescription;
@synthesize txtAmount;
@synthesize txtDeadline;

@synthesize addGoalTB;

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
	
    txtDescription.backgroundColor = [UIColor clearColor];
    txtDescription.textColor = [UIColor lightGrayColor];
    txtDescription.text = @"Goal Description";
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tap];
    
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
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
    [super viewDidUnload];
}
- (IBAction)btnDone:(id)sender {
}
@end

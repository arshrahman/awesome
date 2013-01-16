//
//  ByMonthViewController.m
//  ToTe
//
//  Created by Pol on 16/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ByMonthViewController.h"
#import "CustomDateUIPickerView.h"

@interface ByMonthViewController ()

@end

@implementation ByMonthViewController

@synthesize customDate;

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
    [customDate setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCalender:(id)sender
{
    NSLog(@"paul");
    [customDate setHidden:NO];
    btnCalendar.image = [UIImage imageNamed:@"glyphicons_002_dog.png"];
    
}


@end

//
//  AddGoalViewController.h
//  ToTe
//
//  Created by Abdul Rahman on 28/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGoalViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSDate *deadline;
    UIActionSheet *dateSheet;
}

@property (strong, nonatomic) IBOutlet UITableView *addGoalTB;
@property (weak, nonatomic) IBOutlet UITextField *txtGoal;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtDeadline;
@property (nonatomic, retain) NSDate *deadline;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;


- (IBAction)btnDone:(id)sender;

-(void)DoDeadline;
-(void)DismissDateSet;
-(void)CancelDateSet;
- (NSString *)documentsPathForFileName:(NSString *)name;

@end

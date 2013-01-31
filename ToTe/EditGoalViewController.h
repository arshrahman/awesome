//
//  EditGoalViewController.h
//  ToTe
//
//  Created by Abdul Rahman on 31/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditGoalViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    NSDate *deadline;
    UIActionSheet *dateSheet;
    IBOutlet UIButton *btnCancel;
}

@property(nonatomic)NSMutableArray *goalArray;

@property (strong, nonatomic) IBOutlet UITableView *addGoalTB;
@property (weak, nonatomic) IBOutlet UITextField *txtGoal;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtDeadline;
@property (nonatomic, retain) NSDate *deadline;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblSave;


- (IBAction)btnDone:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnCancelEdit:(id)sender;


-(void)DoDeadline;
-(void)DismissDateSet;
-(void)CancelDateSet;
-(NSString *)documentsPathForFileName:(NSString *)name;
-(void)ChangelblSave;
-(NSString *)ConvertDateFormatToOriginal:(NSString *)end_date;
- (void)showConfirmAlert;

@end
